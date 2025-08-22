import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/base_card.dart';
import '../../../../core/widgets/buttons/outline_primary_button.dart';
import '../pages/on_the_way_page.dart';
import 'info_tile.dart';

class BatchCardItem extends StatelessWidget {
  const BatchCardItem({
    super.key,
    required this.batch,
    this.action,
  });

  final Batch batch;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  '${batch.origin} - ${batch.destination}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              action ?? const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 10),
          GridView.count(
            childAspectRatio: 2.5 / 1,
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              InfoTile(
                title: 'Batch',
                value: batch.batch,
              ),
              InfoTile(
                title: 'Jalur',
                value: batch.path,
              ),
              InfoTile(
                title: 'Total Koli',
                value: '${batch.itemCount}',
              ),
              InfoTile(
                title: 'Tanggal Dikirim',
                value: DateFormat('dd/MM/yyyy').format(batch.sendAt),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinePrimaryButton(
              onPressed: () => context.push(
                '$onTheWayRoute$batchDetailRoute/${batch.id}',
                extra: batch.batch,
              ),
              child: const Text('Detail'),
            ),
          ),
        ],
      ),
    );
  }
}
