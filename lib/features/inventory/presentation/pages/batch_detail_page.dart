import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tri_express/core/routes/router.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/widgets/base_card.dart';
import '../../../../core/widgets/buttons/outline_primary_button.dart';
import '../../../../core/widgets/notification_icon_button.dart';
import '../../../../core/widgets/primary_icon_circle.dart';

class BatchDetailPage extends StatelessWidget {
  const BatchDetailPage({
    super.key,
    required this.batchId,
    required this.title,
  });

  final String batchId;
  final String title;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('$title $batchId'),
        actions: <Widget>[
          const NotificationIconButton(),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari resi atau invoice',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => BaseCard(
                  child: Row(
                    children: <Widget>[
                      const PrimaryIconCircle(
                        icon: Icons.inventory_2_outlined,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'No. Koli',
                            style: const TextStyle(
                              color: black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'Item-$index',
                            style: const TextStyle(
                              color: black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      OutlinePrimaryButton(
                        onPressed: () =>
                            context.push('$path$itemDetailRoute/$index'),
                        child: const Text('Detail'),
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: 20,
                padding: const EdgeInsets.only(bottom: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
