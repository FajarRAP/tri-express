import 'package:flutter/material.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/base_card.dart';
import '../../domain/entities/good_entity.dart';

class GoodCardCheckbox extends StatelessWidget {
  const GoodCardCheckbox({
    super.key,
    this.onChanged,
    this.onTap,
    required this.good,
    this.isActive = false,
  });

  final void Function(bool? value)? onChanged;
  final void Function()? onTap;
  final GoodEntity good;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      borderColor: isActive ? primary : null,
      child: GestureDetector(
        onTap: () => onChanged?.call(!isActive),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Checkbox(
              onChanged: onChanged,
              value: isActive,
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        good.name,
                        style: paragraphMedium[medium].copyWith(color: black),
                      ),
                      Text(
                        '5/10 Koli',
                        style: label[bold].copyWith(color: black),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Nomor Resi',
                        style: label[regular].copyWith(color: gray),
                      ),
                      Text(
                        good.receiptNumber,
                        style: label[regular].copyWith(color: black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: onTap,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          color: black,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateTime.now().toDDMMMMYYYY,
                          style: paragraphSmall[regular],
                        ),
                        const Spacer(),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
