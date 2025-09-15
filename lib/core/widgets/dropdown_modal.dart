import 'package:flutter/material.dart';

import '../fonts/fonts.dart';
import '../themes/colors.dart';
import 'handle_bar.dart';

class DropdownModal extends StatelessWidget {
  const DropdownModal({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 12),
        const HandleBar(),
        const SizedBox(height: 24),
        Text(
          'Pilih $title',
          style: paragraphLarge[bold].copyWith(color: black),
        ),
        const SizedBox(height: 6),
        const Divider(),
        const SizedBox(height: 6),
        child,
        const SizedBox(height: 6),
      ],
    );
  }
}
