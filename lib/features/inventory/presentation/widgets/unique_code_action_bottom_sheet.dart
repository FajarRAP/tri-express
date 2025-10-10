import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'unique_code_input_bottom_sheet.dart';
import '../../../../core/fonts/fonts.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';

class UniqueCodeActionBottomSheet extends StatelessWidget {
  const UniqueCodeActionBottomSheet({
    super.key,
    required this.onScanned,
    required this.onPressed,
  });

  final void Function(String value)? onScanned;
  final void Function(String value)? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Scan Kode Koli',
            style: paragraphMedium[bold].copyWith(color: black),
          ),
          const SizedBox(height: 20),
          ListTile(
            onTap: () async {
              final result =
                  await context.pushNamed<Barcode>(scanBarcodeInnerRoute);
              if (result == null) return;
              onScanned!(result.rawValue!);
            },
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: primary50,
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: primary,
              ),
            ),
            subtitle: const Text('Ambil foto kode koli'),
            title: const Text('Scan dari Kamera'),
          ),
          const Divider(),
          ListTile(
            onTap: () => showModalBottomSheet(
              builder: (context) =>
                  UniqueCodeInputBottomSheet(onPressed: onPressed),
              context: context,
              isScrollControlled: true,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: success50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.edit,
                color: success,
              ),
            ),
            subtitle: const Text('Input manual kode koli'),
            title: const Text('Masukkan kode koli'),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: context.pop,
              style: TextButton.styleFrom(
                foregroundColor: danger,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Batal'),
            ),
          ),
        ],
      ),
    );
  }
}
