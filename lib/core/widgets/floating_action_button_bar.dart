import 'package:flutter/material.dart';

import '../themes/colors.dart';

class FloatingActionButtonBar extends StatelessWidget {
  const FloatingActionButtonBar({
    super.key,
    this.onReset,
    this.onScan,
    this.onSave,
    this.onSync,
    this.isScanning = false,
  });

  final void Function()? onReset;
  final void Function()? onScan;
  final void Function()? onSave;
  final void Function()? onSync;
  final bool isScanning;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
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
            side: const BorderSide(color: danger),
          ),
          tooltip: 'Scan Ulang',
          child: const Icon(Icons.replay),
        ),
        FloatingActionButton.small(
          onPressed: onScan,
          backgroundColor: primary,
          elevation: 1,
          foregroundColor: light,
          heroTag: 'start_stop_scan',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: primary),
          ),
          tooltip: 'Scan',
          child: isScanning
              ? const Icon(Icons.stop)
              : const Icon(Icons.play_arrow),
        ),
        // FloatingActionButton.small(
        //   onPressed: onSync,
        //   backgroundColor: light,
        //   elevation: 1,
        //   foregroundColor: primary,
        //   heroTag: 'sync',
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(8),
        //     side: const BorderSide(color: primary),
        //   ),
        //   tooltip: 'Sinkronkan',
        //   child: const Icon(Icons.send),
        // ),
        FloatingActionButton.small(
          onPressed: onSave,
          backgroundColor: light,
          elevation: 1,
          foregroundColor: primary,
          heroTag: 'save',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: primary),
          ),
          tooltip: 'Simpan',
          child: const Icon(Icons.save),
        ),
      ],
    );
  }
}
