import 'package:flutter/material.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../domain/entities/timeline_entity.dart';

class TimelineIndicator extends StatelessWidget {
  const TimelineIndicator({
    super.key,
    required this.timeline,
    this.isLast = false,
  });

  final TimelineEntity timeline;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                timeline.dateTime.toDDMMMYYY,
                style: label[medium].copyWith(color: black),
              ),
              Text(
                timeline.dateTime.toHHmm,
                style: const TextStyle(
                  color: gray,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              if (isLast)
                const VerticalDivider(color: whiteTertiary, thickness: 2)
              else
                const VerticalDivider(color: primary, thickness: 2),
              Container(
                decoration: const BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
                height: 12,
                width: 12,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  timeline.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: label[medium].copyWith(color: black),
                ),
                Text(
                  timeline.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: gray,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
