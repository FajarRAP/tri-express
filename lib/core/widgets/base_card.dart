import 'package:flutter/material.dart';

import '../themes/colors.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: graySecondary),
        borderRadius: BorderRadius.circular(10),
        color: light,
      ),
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}
