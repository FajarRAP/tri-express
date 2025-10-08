import 'package:flutter/material.dart';

import '../fonts/fonts.dart';
import '../themes/colors.dart';

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
