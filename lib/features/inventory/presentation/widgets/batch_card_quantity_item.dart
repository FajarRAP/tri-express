import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../domain/entity/batch_entity.dart';
import 'batch_card_item.dart';

class BatchCardQuantityItem extends StatelessWidget {
  const BatchCardQuantityItem({
    super.key,
    required this.batch,
  });

  final BatchEntity batch;

  @override
  Widget build(BuildContext context) {
    return BatchCardItem(
      batch: batch,
      action: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.blue.shade50,
        ),
        padding: const EdgeInsets.all(4),
        child: RichText(
          text: TextSpan(
            text: '10',
            style: const TextStyle(
              color: primary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            children: const <InlineSpan>[
              TextSpan(
                text: '/20',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
