import 'package:flutter/material.dart';

import '../themes/colors.dart';

class TripleFloatingActionButtons extends StatelessWidget {
  const TripleFloatingActionButtons({
    super.key,
    this.onReset,
    this.onScan,
    this.onSave,
    this.isScanning = false,
  });

  final void Function()? onReset;
  final void Function()? onScan;
  final void Function()? onSave;
  final bool isScanning;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: <Widget>[
        FloatingActionButton.small(
          onPressed: onReset,
          backgroundColor: light,
          elevation: 1,
          foregroundColor: danger,
          heroTag: 'scan_again',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: danger),
          ),
          tooltip: 'Scan Ulang',
          child: Icon(Icons.restore),
        ),
        FloatingActionButton.small(
          onPressed: onScan,
          backgroundColor: primary,
          elevation: 1,
          foregroundColor: light,
          heroTag: 'start_stop_scan',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: primary),
          ),
          tooltip: 'Scan',
          child: isScanning
              ? const Icon(Icons.stop)
              : const Icon(Icons.play_arrow),
        ),
        FloatingActionButton.small(
          onPressed: onSave,
          backgroundColor: light,
          elevation: 1,
          foregroundColor: primary,
          heroTag: 'save',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: primary),
          ),
          tooltip: 'Simpan',
          child: Icon(Icons.save),
        ),
      ],
    );
  }
}
