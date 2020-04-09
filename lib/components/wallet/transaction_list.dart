import 'dart:async';
import 'package:pblcwallet/model/transactionsModel.dart';
import 'package:pblcwallet/stores/wallet_transactions_store.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  TransactionList(this.store);

  final WalletTransactionsStore store;
  final streamController = StreamController<List<TransactionModel>>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionModel>>(
      stream: streamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<TransactionModel> data = snapshot.data;
          return _transactionsListView(context, data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          _fetchTransactions(context);
        }
        return CircularProgressIndicator();
      },
    );
  }

  _fetchTransactions(BuildContext context) async {
    await store.fetchTransactions(context);
    streamController.add(store.transactionsModel.transactions);
  }

  RefreshIndicator _transactionsListView(BuildContext context, data) {
    return RefreshIndicator(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return _tile(data[index]);
          }),
      onRefresh: () async {
        await _fetchTransactions(context);
      },
    );
  }

  Center _tile(TransactionModel transaction) => Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album),
                title:
                    Text('${transaction.hash}', style: TextStyle(fontSize: 14)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('blockNumber: ${transaction.blockNumber}'),
                    Text('amount: ${transaction.value}'),
                    Text('${transaction.formattedDate()}')
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(transaction.txreceiptStatus == ""
                      ? "pending"
                      : "confirmed"),
                  Text(transaction.to == store.walletStore.address
                      ? "RECEIVED"
                      : "SENT")
                ],
              )
            ],
          ),
        ),
      );
}
