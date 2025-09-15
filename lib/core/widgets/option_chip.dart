import 'package:flutter/material.dart';

import '../fonts/fonts.dart';
import '../themes/colors.dart';

class OptionChip extends StatelessWidget {
  const OptionChip({
    super.key,
    this.onSelected,
    required this.isActive,
    required this.text,
  });

  final void Function(bool value)? onSelected;
  final bool isActive;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      onSelected: onSelected,
      backgroundColor: light,
      label: SizedBox(
        width: double.infinity,
        child: Text(
          text,
          style: label[regular].copyWith(
            color: isActive ? light : black,
          ),
        ),
      ),
      selectedColor: primary,
      selected: isActive,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(
          color: graySecondary,
          width: .8,
        ),
      ),
      showCheckmark: false,
    );
  }
}
