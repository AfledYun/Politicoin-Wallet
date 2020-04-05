import 'package:pblcwallet/main.dart';
import 'package:pblcwallet/processing_transaction_page.dart';
import 'package:pblcwallet/qrcode_reader_page.dart';
import 'package:pblcwallet/service/configuration_service.dart';
import 'package:pblcwallet/stores/wallet_store.dart';
import 'package:pblcwallet/stores/wallet_create_store.dart';
import 'package:pblcwallet/stores/wallet_import_store.dart';
import 'package:pblcwallet/stores/wallet_transfer_store.dart';
import 'package:pblcwallet/wallet_create_page.dart';
import 'package:pblcwallet/wallet_import_page.dart';
import 'package:pblcwallet/wallet_main_page.dart';
import 'package:pblcwallet/wallet_transfer_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'intro_page.dart';

Map<String, WidgetBuilder> getRoutes(context) {
  return {
    '/': (BuildContext context) => Consumer<ConfigurationService>(
            builder: (context, configurationService, _) {
          if (configurationService.didSetupWallet())
            return Consumer<WalletStore>(
              builder: (context, walletStore, _) =>
                  WalletMainPage(walletStore, title: "PBLC wallet", currentNetwork: configurationService.getNetwork(),),
            );

          return IntroPage();
        }),
    '/create': (BuildContext context) => Consumer<WalletCreateStore>(
          builder: (context, walletCreateStore, _) =>
              WalletCreatePage(walletCreateStore, title: "Create wallet"),
        ),
    '/import': (BuildContext context) => Consumer<WalletImportStore>(
          builder: (context, walletImportStore, _) =>
              WalletImportPage(walletImportStore, title: "Import wallet"),
        ),
    '/transfer': (BuildContext context) => Consumer<WalletTransferStore>(
          builder: (context, walletTransferStore, _) =>
              WalletTransferPage(walletTransferStore, title: "Send Tokens"),
        ),
    '/processing-transaction': (BuildContext context) =>
        Consumer<WalletTransferStore>(
          builder: (context, walletTransferStore, _) =>
              ProcessingTransactionPage(title: "Sending Tokens"),
        ),
    '/qrcode_reader': (BuildContext context) => QRCodeReaderPage(
          title: "Scan QRCode",
          onScanned: ModalRoute.of(context).settings.arguments,
        )
  };
}
