import 'package:flutter/material.dart';

import '../themes/colors.dart';

class DecoratedIconButton extends StatelessWidget {
  const DecoratedIconButton({
    super.key,
    this.onTap,
    required this.icon,
  });

  final void Function()? onTap;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: whiteTertiary),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              blurRadius: 4,
              color: Color(0x4D3F3F3F),
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
          color: light,
        ),
        height: 45,
        width: 45,
        child: icon,
      ),
    );
  }
}
