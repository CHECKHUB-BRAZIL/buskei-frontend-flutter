import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({
    super.key,
  });

  @override
  State<QRCodeScannerPage> createState() =>
      _QRCodeScannerPageState();
}

class _QRCodeScannerPageState
    extends State<QRCodeScannerPage> {
  bool _hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text(
          'Escanear QR Code',
        ),
      ),

      body: MobileScanner(
        onDetect: (capture) {
          if (_hasScanned) return;

          final barcode =
              capture.barcodes.first;

          final value = barcode.rawValue;

          if (value == null) return;

          _hasScanned = true;

          Navigator.pop(
            context,
            value,
          );
        },
      ),
    );
  }
}
