import 'package:flutter/material.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/badges/success_badge.dart';
import '../../../../core/widgets/base_card.dart';
import '../../domain/entities/batch_entity.dart';

class BatchCardActionBadgeItem extends StatelessWidget {
  const BatchCardActionBadgeItem({
    super.key,
    this.onTap,
    this.onDelete,
    required this.batch,
  });

  final void Function()? onTap;
  final void Function()? onDelete;
  final BatchEntity batch;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SuccessBadge(label: 'Success'),
              GestureDetector(
                onTap: onDelete,
                child: Text(
                  'Hapus',
                  style: label[medium].copyWith(color: danger),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                batch.name,
                style: paragraphMedium[medium].copyWith(color: black),
              ),
              Text(
                '${batch.goods.length} Koli',
                style: label[bold].copyWith(color: black),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'No Pengiriman',
                style: label[regular].copyWith(color: gray),
              ),
              Text(
                batch.trackingNumber,
                style: label[medium].copyWith(color: black),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Gudang Tujuan',
                style: label[regular].copyWith(color: gray),
              ),
              Text(
                batch.destination.name,
                style: label[medium].copyWith(color: black),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Jalur Pengiriman',
                style: label[regular].copyWith(color: gray),
              ),
              Text(
                batch.transportMode,
                style: label[medium].copyWith(color: black),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                  color: black,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  batch.sendAt.toLocal().toDDMMMMYYYY,
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
    );
  }
}
