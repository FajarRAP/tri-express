import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
              const NotificationIconButton(),
              const SizedBox(width: 16),
            ],
            expandedHeight: kToolbarHeight + kSpaceBarHeight,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Cari resi atau invoice',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            pinned: true,
            snap: true,
            title: Text('$title $batchId'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
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
                    SizedBox(
                      width: 80,
                      child: OutlinePrimaryButton(
                        onPressed: () =>
                            context.push('$path$itemDetailRoute/$index'),
                        child: const Text('Detail'),
                      ),
                    ),
                  ],
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
          ),
        ],
      ),
    );
  }
}
