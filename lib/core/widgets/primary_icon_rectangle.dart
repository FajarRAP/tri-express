import 'package:flutter/material.dart';

import '../themes/colors.dart';

class PrimaryIconRectangle extends StatelessWidget {
  const PrimaryIconRectangle({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: lightBlue,
        shape: BoxShape.rectangle,
      ),
      padding: const EdgeInsets.all(10),
      child: Icon(
        icon,
        color: primary,
      ),
    );
  }
}
