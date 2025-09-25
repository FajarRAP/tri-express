import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.title,
    required this.value,
    this.isCopyable = false,
  });

  final String title;
  final String value;
  final bool isCopyable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: gray,
          ),
        ),
        _renderValue(),
      ],
    );
  }

  Widget _renderValue() {
    if (!isCopyable) {
      return Text(
        value,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: label[medium].copyWith(color: black),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: label[medium].copyWith(color: black),
          ),
        ),
        IconButton(
          onPressed: () => Clipboard.setData(ClipboardData(text: value)),
          icon: const Icon(
            Icons.copy,
            color: graySecondary,
            size: 16,
          ),
        )
      ],
    );
  }
}
