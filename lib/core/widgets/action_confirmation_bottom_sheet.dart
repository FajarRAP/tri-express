import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../fonts/fonts.dart';
import '../themes/colors.dart';
import 'buttons/outline_primary_button.dart';
import 'buttons/primary_button.dart';

class ActionConfirmationBottomSheet extends StatelessWidget {
  const ActionConfirmationBottomSheet({
    super.key,
    this.onPressed,
    required this.message,
  });

  final void Function()? onPressed;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Konfirmasi Aksi',
            style: paragraphLarge[semibold],
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Apakah anda yakin akan menyimpan barang ini?',
            style: label[medium].copyWith(color: grayTertiary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinePrimaryButton(
                  onPressed: context.pop,
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  onPressed: onPressed,
                  child: const Text('Ya, Yakin'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
