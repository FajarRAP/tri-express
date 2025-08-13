import 'package:flutter/material.dart';

import '../themes/colors.dart';

class PrimaryIconCircle extends StatelessWidget {
  const PrimaryIconCircle({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightBlue,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(10),
      child: Icon(
        icon,
        color: primary,
      ),
    );
  }
}
