import 'package:flutter/material.dart';

import '../../themes/colors.dart';

class DangerButton extends StatelessWidget {
  const DangerButton({
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
        backgroundColor: danger,
        foregroundColor: light,
      ),
      icon: icon,
      label: child,
    );
  }
}
