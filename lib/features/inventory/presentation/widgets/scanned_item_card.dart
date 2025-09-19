import 'package:flutter/material.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../../core/domain/entities/uhf_result_entity.dart';

class ScannedItemCard extends StatelessWidget {
  const ScannedItemCard({
    super.key,
    required this.number,
    required this.item,
  });

  final int number;
  final UHFResultEntity item;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: light,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primary,
          child: Text(
            '$number',
            style: label[semibold].copyWith(color: light),
          ),
        ),
        title: const Text(
          'Kode EPC Terbaca',
          style: TextStyle(
            color: grayTertiary,
            fontSize: 12,
          ),
        ),
        subtitle: Text(
          item.epcId,
          style: paragraphSmall[semibold].copyWith(color: black),
        ),
      ),
    );
  }
}
