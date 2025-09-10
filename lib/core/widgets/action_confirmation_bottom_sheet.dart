import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tri_express/core/fonts/fonts.dart';
import 'package:tri_express/core/themes/colors.dart';
import 'package:tri_express/core/widgets/buttons/outline_primary_button.dart';
import 'package:tri_express/core/widgets/buttons/primary_button.dart';

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
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 24),
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
