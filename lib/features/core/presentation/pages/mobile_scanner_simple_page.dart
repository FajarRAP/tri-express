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
                actions: [
                  Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: whiteTertiary,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: _controller,
                      builder: (context, state, child) {
                        if (!state.isInitialized || !state.isRunning) {
                          return const SizedBox.shrink();
                        }

                        return switch (state.torchState) {
                          TorchState.off => IconButton(
                              onPressed: _controller.toggleTorch,
                              icon: const Icon(
                                Icons.flashlight_on,
                                color: black,
                              ),
                            ),
                          TorchState.unavailable => IconButton(
                              onPressed: _controller.toggleTorch,
                              icon: const Icon(
                                Icons.no_flash,
                                color: black,
                              ),
                            ),
                          _ => IconButton(
                              onPressed: _controller.toggleTorch,
                              icon: const Icon(
                                Icons.flashlight_off,
                                color: black,
                              ),
                            )
                        };
                      },
                    ),
                  ),
                ],
                backgroundColor: Colors.transparent,
                leading: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: whiteTertiary,
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.all(8),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: black),
                    onPressed: context.pop,
                  ),
                ),
                title: Text(
                  'Scan QR Code',
                  style: paragraphMedium[bold].copyWith(color: light),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
