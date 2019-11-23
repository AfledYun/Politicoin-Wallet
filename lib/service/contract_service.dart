import 'dart:async';
import 'package:web3dart/web3dart.dart';

typedef TransferEvent = void Function(
    EthereumAddress from, EthereumAddress to, BigInt value);

abstract class IContractService {
  Future<Credentials> getCredentials(String privateKey);

  Future<String> send(String privateKey, 
                      EthereumAddress receiver, 
                      BigInt amount, 
                      {TransferEvent onTransfer, 
                      Function onError});

  Future<String> sendEth(String privateKey, 
                          EthereumAddress receiver, 
                          BigInt amount, 
                          {TransferEvent onTransfer, 
                          Function onError});

  Future<BigInt> getTokenBalance(EthereumAddress from);

  Future<EtherAmount> getEthBalance(EthereumAddress from);

  Future<void> dispose();

  StreamSubscription listenTransfer(TransferEvent onTransfer);

  Future<EtherAmount> getEthGasPrice();
}

class ContractService implements IContractService {
  ContractService(this.client, this.contract);

  final Web3Client client;
  final DeployedContract contract;

  ContractEvent _transferEvent() => contract.event('Transfer');
  ContractFunction _balanceFunction() => contract.function('balanceOf');
  ContractFunction _sendFunction() => contract.function('transfer');

  Future<Credentials> getCredentials(String privateKey) =>
      client.credentialsFromPrivateKey(privateKey);

  Future<String> send(String privateKey, 
                      EthereumAddress receiver, 
                      BigInt amount, 
                      {TransferEvent onTransfer, 
                      Function onError}) async {
    final credentials = await this.getCredentials(privateKey);
    final from = await credentials.extractAddress();
    final networkId = await client.getNetworkId();

    StreamSubscription event;
    // Work around once sendTransacton doesn't return a Promise containing confirmation / receipt
    if (onTransfer != null) {
      event = listenTransfer((from, to, value) async {
        onTransfer(from, to, value);
        await event.cancel();
      }, take: 1);
    }

    try {
      final transactionId = await client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: _sendFunction(),
          gasPrice: EtherAmount.inWei(BigInt.from(1000000000)), // ZOIS: set it in UI
          maxGas: 3000000, // ZOIS: set it in UI
          parameters: [receiver, amount],
          from: from,
        ),
        chainId: networkId,
      );
      print('transact started $transactionId');
      return transactionId;
    } catch (ex) {
      if (onError != null) {
        onError(ex);
      }
      return null;
    }
  }

  Future<String> sendEth(String privateKey, 
                          EthereumAddress receiver, 
                          BigInt amount, 
                          {TransferEvent onTransfer, 
                          Function onError}) async {
    final credentials = await this.getCredentials(privateKey);
    final networkId = await client.getNetworkId();
    final from = await credentials.extractAddress();

    try {
      final transactionId = await client.sendTransaction(
        credentials,
        Transaction(
          to: receiver,
          gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
          maxGas: 3000000,
          value: EtherAmount.fromUnitAndValue(EtherUnit.wei, amount),
        ),
        chainId: networkId,
      );
      print('transact started $transactionId');
      onTransfer(from, receiver, amount);
      return transactionId;
    } catch (ex) {
      if (onError != null) {
        onError(ex);
      }
      return null;
    }
  }

  Future<EtherAmount> getEthBalance(EthereumAddress from) async {
    return await client.getBalance(from);
  }

  Future<EtherAmount> getEthGasPrice() async {
    return await client.getGasPrice();
  }

  Future<BigInt> getTokenBalance(EthereumAddress from) async {
    try {
      var response = await client.call(
        contract: contract,
        function: _balanceFunction(),
        params: [from],
      );

      return response.first as BigInt;
    }
    catch (e) {
      print("${e.toString()} \n Couldn't get PBLC balance for address: $from");
      return BigInt.from(0);
    }
  }

  StreamSubscription listenTransfer(TransferEvent onTransfer, {int take}) {
    var events = client.events(FilterOptions.events(
      contract: contract,
      event: _transferEvent(),
    ));

    if (take != null) {
      events = events.take(take);
    }

    return events.listen((event) {
      final decoded = _transferEvent().decodeResults(event.topics, event.data);

      final from = decoded[0] as EthereumAddress;
      final to = decoded[1] as EthereumAddress;
      final value = decoded[2] as BigInt;

      onTransfer(from, to, value);
    });
  }

  Future<void> dispose() async {
    await client.dispose();
  }
}
