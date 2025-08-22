import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/notification_icon_button.dart';
import '../../../../core/widgets/primary_gradient_card.dart';
import '../../domain/entity/batch_entity.dart';
import '../widgets/batch_card_status_item.dart';

class OnTheWayPage extends StatelessWidget {
  const OnTheWayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final batches = BatchEntity.generate(20);

    return Scaffold(
      appBar: AppBar(
        title: const Text('On The Way'),
        actions: <Widget>[
          const NotificationIconButton(),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          PrimaryGradientCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Dalam Pengiriman ke \$Warehouse Location',
                  style: const TextStyle(
                    color: light,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Number',
                  style: const TextStyle(
                    color: light,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ListView.separated(
            itemBuilder: (context, index) =>
                BatchCardStatusItem(batch: batches[index]),
            separatorBuilder: (context, index) => const SizedBox(height: 24),
            itemCount: batches.length,
            padding: const EdgeInsets.only(bottom: 24),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          )
        ],
      ),
    );
  }
}
