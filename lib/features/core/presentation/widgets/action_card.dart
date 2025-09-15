import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/primary_icon_rectangle.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    this.onTap,
    required this.icon,
    required this.title,
  });

  final void Function()? onTap;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: graySecondary),
          borderRadius: BorderRadius.circular(30),
          color: light,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            PrimaryIconRectangle(icon: icon),
          ],
        ),
      ),
    );
  }
}
