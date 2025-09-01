import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/base_card.dart';
import '../../domain/entity/batch_entity.dart';

class BatchCardItem extends StatelessWidget {
  const BatchCardItem({
    super.key,
    required this.batch,
    this.action,
  });

  final BatchEntity batch;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    const spacing = 12.0;

    return BaseCard(
      child: InkWell(
        onTap: () => context.push(
          '$onTheWayRoute$batchDetailRoute/${batch.id}',
          extra: batch.batch,
        ),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            batch.batch,
                            style: const TextStyle(
                              color: black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.blue.shade50,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Text.rich(
                              TextSpan(
                                text: '10',
                                style: const TextStyle(
                                  color: primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                                children: const <InlineSpan>[
                                  TextSpan(
                                    text: '/20',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${batch.origin} → ${batch.destination}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                action ?? const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: spacing),
            const Divider(height: 1),
            const SizedBox(height: spacing),
            Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey.shade600,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd MMMM yyyy').format(batch.sendAt.toLocal()),
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
