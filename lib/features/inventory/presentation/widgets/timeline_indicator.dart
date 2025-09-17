import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/colors.dart';

class TimelineIndicator extends StatelessWidget {
  const TimelineIndicator({
    super.key,
    required this.timeline,
  });

  final Timeline timeline;

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
                DateFormat('dd MMMM').format(timeline.dateTime),
                style: const TextStyle(
                  color: black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                DateFormat('HH:mm').format(timeline.dateTime),
                style: const TextStyle(
                  color: gray,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: <Widget>[
              const VerticalDivider(color: primary, thickness: 2),
              Container(
                decoration: const BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
                height: 16,
                width: 16,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                timeline.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
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
      ],
    );
  }
}

class Timeline {
  const Timeline({
    required this.dateTime,
    required this.description,
    required this.address,
  });

  final DateTime dateTime;
  final String description;
  final String address;

  static List<Timeline> generate(int count) => List.generate(
        count,
        (index) => Timeline(
          dateTime: faker.date.dateTime(),
          description: faker.lorem.sentence(),
          address: faker.address.streetAddress(),
        ),
      );
}
