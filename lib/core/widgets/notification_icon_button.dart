import 'package:flutter/material.dart';

import '../themes/colors.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: graySecondary),
          // boxShadow: <BoxShadow>[
          //   BoxShadow(
          //     blurRadius: 4,
          //     color: Color(0x4D3F3F3F),
          //     offset: const Offset(0, 1),
          //     spreadRadius: 0,
          //   )
          // ],
          // color: Color(0xFFEEEEEE),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(
          Icons.notifications_outlined,
          color: black,
        ),
      ),
    );
  }
}
