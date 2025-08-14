import 'package:flutter/material.dart';

import '../themes/colors.dart';

class PrimaryGradientCard extends StatelessWidget {
  const PrimaryGradientCard({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: <Color>[
            primary,
            primaryGradientEnd,
          ],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}
