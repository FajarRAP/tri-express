import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/router.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../../domain/entity/batch_entity.dart';
import '../../widgets/batch_card_status_item.dart';

class PrepareGoodsPage extends StatelessWidget {
  const PrepareGoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final batches = BatchEntity.generate(10);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: <Widget>[
                const NotificationIconButton(),
                const SizedBox(width: 16),
              ],
              bottom: TabBar(
                tabs: const <Widget>[
                  Tab(text: 'Persiapan'),
                  Tab(text: 'Siap Kirim'),
                ],
              ),
              expandedHeight: kToolbarHeight + kSpaceBarHeight + 32,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  alignment: const Alignment(0, .25),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari resi atau invoice',
                            prefixIcon: const Icon(Icons.search_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      DecoratedIconButton(
                        onTap: () => context.push(filterPrepareGoodsRoute),
                        icon: const Icon(Icons.add_outlined),
                      ),
                    ],
                  ),
                ),
              ),
              pinned: true,
              snap: true,
              title: const Text('Persiapan Barang'),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: <Widget>[
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        'Klik tombol “+” untuk mempersiapkan barang yang ingin dikirim',
                        style: TextStyle(color: grayTertiary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  ListView.separated(
                    itemBuilder: (context, index) =>
                        BatchCardStatusItem(batch: batches[index]),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemCount: batches.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
