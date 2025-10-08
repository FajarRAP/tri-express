import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../themes/colors.dart';

class PrimaryIconRectangle extends StatelessWidget {
  const PrimaryIconRectangle({
    super.key,
    required this.icon,
  });

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: lightBlue,
        shape: BoxShape.rectangle,
      ),
      padding: const EdgeInsets.all(10),
      child: SvgPicture.asset(
        icon,
        colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
      ),
    );
  }
}
