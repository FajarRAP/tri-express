import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/entities/good_entity.dart';

class ReceiptNumberItem extends StatelessWidget {
  const ReceiptNumberItem({
    super.key,
    this.onTap,
    required this.good,
  });

  final void Function()? onTap;
  final GoodEntity good;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: graySecondary),
        borderRadius: BorderRadius.circular(10),
        color: light,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: primary50,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(
              boxSvgPath,
              colorFilter: const ColorFilter.mode(
                primary,
                BlendMode.srcIn,
              ),
              width: 20,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            good.receiptNumber,
            style: label[bold].copyWith(color: black),
          ),
          const Spacer(),
          TextButton(
            onPressed: onTap,
            child: const Text('Lihat Detail'),
          ),
        ],
      ),
    );
  }
}
