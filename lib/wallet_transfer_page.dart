import 'package:pblcwallet/components/form/paper_form.dart';
import 'package:pblcwallet/components/form/paper_input.dart';
import 'package:pblcwallet/components/form/paper_validation_summary.dart';
import 'package:pblcwallet/components/form/paper_gasprice.dart';
import 'package:pblcwallet/model/transaction.dart';
import 'package:pblcwallet/stores/wallet_transfer_store.dart';
import 'package:pblcwallet/stores/wallet_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class WalletTransferPage extends StatefulWidget {
  WalletTransferPage(this.store, {Key key, this.title}) : super(key: key);

  final WalletTransferStore store;
  final String title;

  @override
  _WalletTransferPageState createState() => _WalletTransferPageState();
}

class _WalletTransferPageState extends State<WalletTransferPage> {
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.store.reset();
    _popForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.of(context).pushNamed("/qrcode_reader",
                  arguments: (ethAddress) async {
                widget.store.setTo(ethAddress);
                _popForm();
              });
            },
          ),
        ],
      ),
      body: buildForm(),
    );
  }

  Widget buildForm() {
    return SingleChildScrollView(
      child: Observer(
        builder: (_) {
          return PaperForm(
            padding: 50,
            children: <Widget>[
              PaperValidationSummary(widget.store.errors),
              PaperInput(
                controller: _toController,
                labelText: 'To',
                hintText: 'Type the destination address',
                onChanged: widget.store.setTo,
              ),
              PaperInput(
                controller: _amountController,
                labelText: 'Amount',
                hintText: 'PBLC or ETH(in wei)',
                onChanged: widget.store.setAmount,
              ),
              Container(margin: EdgeInsets.all(15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    child: const Text('Transfer PBLC'),
                    onPressed: !widget.store.loading
                        ? () {
                            widget.store.transfer().listen((tx) {
                              switch (tx.status) {
                                case TransactionStatus.started:
                                  Navigator.pushNamed(context, '/transactions');
                                  break;
                                case TransactionStatus.confirmed:
                                  //Navigator.popUntil(context, ModalRoute.withName('/'));
                                  break;
                                default:
                                  break;
                              }
                            }).onError((error) =>
                                widget.store.setError(error.message));
                          }
                        : null,
                  ),
                  RaisedButton(
                    child: const Text('Transfer ETH'),
                    onPressed: !widget.store.loading
                        ? () => widget.store.transferEth()
                        : null,
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     RaisedButton(
                  //       child: const Text('get gas price'),
                  //       onPressed: !widget.store.loading
                  //           ? () => widget.store.getEthGasPrice()
                  //           : null,
                  //     ),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     PaperGasPrice(_getEthGasPrice()),
                  //   ],
                  // )
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _popForm() {
    _toController.value = TextEditingValue(text: widget.store.to ?? "");
    _amountController.value = TextEditingValue(text: widget.store.amount ?? "");
  }

  String _getEthGasPrice() {
    var price = widget.store.ethGasPrice ?? "";
    return price;
  }

  @override
  void dispose() {
    _toController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
