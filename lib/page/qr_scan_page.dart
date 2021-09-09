import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_code_scanner_example/page/login.dart';
import 'package:qr_code_scanner_example/repos/auth.dart';
import 'package:qr_code_scanner_example/repos/user_repos.dart';
import 'package:qr_code_scanner_example/widget/button_widget.dart';

import '../main.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String qrCode = 'Unknown';
  final _userRepo = UserRepo();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Scan ticket"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonWidget(
                text: 'Start QR scan',
                onClicked: () => scanQRCode(),
              ),
              ButtonWidget(
                text: 'Logout',
                onClicked: () async {
                  AuthRepo authRepo = AuthRepo();
                  authRepo.signOut().then((value) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => SignInScreen()));
                  });
                },
              ),
            ],
          ),
        ),
      );

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
        _userRepo.checkIn(qrCode).then((value) {
          if (value['type'] != null) {
            _showDangerMessage(value['message']);
          } else {
            _showSuccessMessage(value['message']);
          }
        });
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }

  _showSuccessMessage(String text) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.green,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _showDangerMessage(String text) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
