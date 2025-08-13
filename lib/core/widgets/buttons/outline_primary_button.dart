import 'package:flutter/material.dart';

import '../../themes/colors.dart';

class OutlinePrimaryButton extends StatelessWidget {
  const OutlinePrimaryButton({
    super.key,
    this.onPressed,
    required this.child,
  });

  final void Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: light,
        foregroundColor: primary,
        side: const BorderSide(color: primary),
      ),
      child: child,
    );
  }
}
