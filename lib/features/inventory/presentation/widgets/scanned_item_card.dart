import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../core/domain/entities/uhf_result_entity.dart';

class ScannedItemCard extends StatelessWidget {
  const ScannedItemCard({
    super.key,
    required this.item,
  });

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
        leading: Container(
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
        title: const Text(
          'Nomor Koli',
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
