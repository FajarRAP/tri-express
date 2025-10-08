import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
  });

  final NotificationEntity notification;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: border),
          ),
        ),
        padding: const EdgeInsets.only(bottom: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              notification.title,
              style: label[bold].copyWith(color: black),
            ),
            RichText(
              text: TextSpan(
                text: notification.message,
                style: const TextStyle(
                  color: black,
                  fontSize: 12,
                ),
                children: <InlineSpan>[
                  TextSpan(
                    text: ' ${format(notification.createdAt, locale: 'id')}',
                    style: const TextStyle(
                      color: gray,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
