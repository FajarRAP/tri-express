import 'package:flutter/material.dart';

class BaseBadge extends StatelessWidget {
  const BaseBadge({
    super.key,
    required this.color,
    required this.child,
  });

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: child,
    );
  }
}
