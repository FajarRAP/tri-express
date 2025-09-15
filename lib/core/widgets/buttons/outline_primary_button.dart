import 'package:flutter/material.dart';

import '../../themes/colors.dart';

class OutlinePrimaryButton extends StatelessWidget {
  const OutlinePrimaryButton({
    super.key,
    this.onPressed,
    this.icon,
    required this.child,
  });

  final void Function()? onPressed;
  final Widget? icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: light,
        foregroundColor: primary,
        overlayColor: primary,
        surfaceTintColor: primary,
        shadowColor: Colors.transparent,
        side: onPressed != null ? const BorderSide(color: primary) : null,
      ),
      icon: icon,
      label: child,
    );
  }
}
