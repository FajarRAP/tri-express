import 'package:flutter/material.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';

class DataCard extends StatelessWidget {
  const DataCard({
    super.key,
    required this.number,
    required this.icon,
    required this.text,
  });

  final int number;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: lightBlue),
        borderRadius: BorderRadius.circular(14),
        color: light,
      ),
      height: 80,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$number',
            style: paragraphMedium[medium].copyWith(color: black),
          ),
          Text(
            text,
            style: label[regular].copyWith(
              color: grayTertiary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
