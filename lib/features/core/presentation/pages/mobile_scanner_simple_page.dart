import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';

/// Implementation of Mobile Scanner example with simple configuration
class MobileScannerSimplePage extends StatefulWidget {
  /// Constructor for simple Mobile Scanner example
  const MobileScannerSimplePage({
    super.key,
    required this.onDetect,
  });

  final void Function(Barcode? barcode) onDetect;

  @override
  State<MobileScannerSimplePage> createState() => _MobileScannerSimpleState();
}

class _MobileScannerSimpleState extends State<MobileScannerSimplePage> {
  late MobileScannerController _controller;
  Barcode? _barcode;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (!mounted) return;

    final barcode = barcodes.barcodes.firstOrNull;
    if (barcode == null) return;

    _controller.stop();
    _barcode = barcodes.barcodes.firstOrNull;
    widget.onDetect(_barcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
            controller: _controller,
          ),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: light),
                  onPressed: context.pop,
                ),
                title: Text(
                  'Scan QR Code',
                  style: paragraphMedium[bold].copyWith(color: light),
                ),
              ),
            ],
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     alignment: Alignment.bottomCenter,
          //     height: 100,
          //     color: light,
          //     child: Column(
          //       children: [
          //         Text('data: ${_barcode?.rawValue ?? '---'}'),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
