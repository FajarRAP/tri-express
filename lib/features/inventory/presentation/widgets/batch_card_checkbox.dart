import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/base_card.dart';
import '../../domain/entities/batch_entity.dart';

class BatchCardCheckbox extends StatelessWidget {
  const BatchCardCheckbox({
    super.key,
    this.onChanged,
    this.onTap,
    required this.batch,
    this.isActive = false,
    this.quantity,
  });

  final void Function(bool? value)? onChanged;
  final void Function()? onTap;
  final BatchEntity batch;
  final bool isActive;
  final Widget? quantity;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      borderColor: isActive ? primary : null,
      child: GestureDetector(
        onTap: onChanged == null ? null : () => onChanged!(!isActive),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              onChanged: onChanged,
              value: isActive,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Top Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  batch.name,
                                  style: paragraphMedium[medium],
                                ),
                                quantity ??
                                    Text(
                                      '${batch.totalAllUnits} Koli',
                                      style: label[bold].copyWith(color: black),
                                    ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                text: 'No. Pengiriman: ',
                                style: label[regular].copyWith(color: gray),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: batch.trackingNumber,
                                    style:
                                        label[regular].copyWith(color: black),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${batch.origin.name} → ${batch.destination.name}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: label[regular].copyWith(color: gray),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  // Bottom Section
                  GestureDetector(
                    onTap: onTap,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.calendar_today,
                          color: black,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            batch.shippedAt.toLocal().toDDMMMYYY,
                            style: paragraphSmall[regular],
                          ),
                        ),
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
