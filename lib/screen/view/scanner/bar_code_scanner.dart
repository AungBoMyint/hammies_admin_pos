import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarCodeScanner extends StatelessWidget {
  const BarCodeScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: MobileScanner(
              allowDuplicates: false,
              onDetect: (barcode, args) {
                final String? code = barcode.rawValue;
                debugPrint('Barcode found! $code');
              }),
        ),
      ),
    );
  }
}
