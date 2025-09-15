import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/primary_gradient_card.dart';

class InventorySummaryCard extends StatelessWidget {
  const InventorySummaryCard({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final int value;

  @override
  Widget build(BuildContext context) {
    return PrimaryGradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              color: light,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(
              color: light,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
