import 'package:flutter/material.dart';

import '../../themes/colors.dart';
import 'base_badge.dart';

class WarningBadge extends StatelessWidget {
  const WarningBadge({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return BaseBadge(
      color: warning,
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
