import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';

class DataCard extends StatelessWidget {
  const DataCard({
    super.key,
    required this.number,
    required this.icon,
    required this.label,
  });

  final int number;
  final IconData icon;
  final String label;

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
            style: TextStyle(
              color: black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: grayTertiary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          // Row(
          //   children: <Widget>[
          //     Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: <Widget>[
          //         Icon(
          //           icon,
          //           color: grayTertiary,
          //           size: 16,
          //         ),
          //         const SizedBox(width: 6),
          //         Text(
          //           label,
          //           style: TextStyle(
          //             color: grayTertiary,
          //             fontSize: 14,
          //             fontWeight: FontWeight.w400,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
