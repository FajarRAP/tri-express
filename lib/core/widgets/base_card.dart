import 'package:flutter/material.dart';

import '../themes/colors.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({
    super.key,
    this.backgroundColor,
    this.borderColor,
    required this.child,
  });

  final Color? backgroundColor;
  final Color? borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? graySecondary),
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor ?? light,
      ),
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}
