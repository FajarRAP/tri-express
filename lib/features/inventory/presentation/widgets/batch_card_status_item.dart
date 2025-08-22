import 'package:flutter/material.dart';

import '../../../../core/widgets/badges/secondary_badge.dart';
import '../../../../core/widgets/badges/success_badge.dart';
import '../../../../core/widgets/badges/warning_badge.dart';
import '../pages/on_the_way_page.dart';
import 'batch_card_item.dart';

class BatchCardStatusItem extends StatelessWidget {
  const BatchCardStatusItem({
    super.key,
    required this.batch,
  });

  final Batch batch;

  @override
  Widget build(BuildContext context) {
    const status = <String, dynamic>{
      'Selesai': SuccessBadge(label: 'Selesai'),
      'Sedang Dikirim': WarningBadge(label: 'Sedang Dikirim'),
      'Terjadwal': SecondaryBadge(label: 'Terjadwal')
    };

    return BatchCardItem(
      batch: batch,
      action: status[batch.status],
    );
  }
}
