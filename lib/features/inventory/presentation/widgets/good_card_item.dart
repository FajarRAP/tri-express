import 'package:flutter/material.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/base_card.dart';
import '../../domain/entities/picked_good_entity.dart';

class GoodCardItem extends StatelessWidget {
  const GoodCardItem({
    super.key,
    this.onTap,
    required this.pickedGood,
  });

  final void Function()? onTap;
  final PickedGoodEntity pickedGood;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                pickedGood.name,
                style: paragraphMedium[medium].copyWith(color: black),
              ),
              Text(
                '${pickedGood.totalItem} Koli',
                style: label[bold].copyWith(color: black),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Nama Customer',
                style: label[regular].copyWith(color: gray),
              ),
              Text(
                pickedGood.customer.name,
                style: label[regular].copyWith(color: black),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Nomor Resi',
                style: label[regular].copyWith(color: gray),
              ),
              Text(
                pickedGood.receiptNumber,
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
                const Icon(
                  Icons.calendar_today,
                  color: black,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  pickedGood.deliveredAt.toDDMMMMYYYY,
                  style: paragraphSmall[regular],
                ),
                const Spacer(),
                Icon(
                  Icons.keyboard_arrow_right,
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
