import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/router.dart';
import '../themes/colors.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(notificationRoute),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: graySecondary),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(10),
        child: const Icon(
          Icons.notifications_outlined,
          color: black,
        ),
      ),
    );
  }
}
