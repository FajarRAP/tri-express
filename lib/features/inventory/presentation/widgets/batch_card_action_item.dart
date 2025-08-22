import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../domain/entity/batch_entity.dart';
import 'batch_card_item.dart';

class BatchCardActionItem extends StatelessWidget {
  const BatchCardActionItem({
    super.key,
    required this.batch,
  });

  final BatchEntity batch;

  @override
  Widget build(BuildContext context) {
    return BatchCardItem(
      batch: batch,
      action: PopupMenuButton(
        itemBuilder: (context) => <PopupMenuEntry>[
          PopupMenuItem(
            onTap: () => debugPrint('Deleted ${batch.id}'),
            value: 'action_1',
            child: Text(
              'Hapus Batch',
              style: const TextStyle(
                color: danger,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        color: light,
        icon: const Icon(Icons.more_horiz_outlined),
        menuPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
