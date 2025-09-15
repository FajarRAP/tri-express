import 'package:flutter/material.dart';

import '../../themes/colors.dart';
import 'base_badge.dart';

class SuccessBadge extends StatelessWidget {
  const SuccessBadge({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return BaseBadge(
      color: success,
      child: Text(
        label,
        style: const TextStyle(
          color: light,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
