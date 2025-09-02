import 'package:flutter/material.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../widgets/batch_card_quantity_item.dart';

class SendGoodsPage extends StatelessWidget {
  const SendGoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: const <Widget>[
              NotificationIconButton(),
              SizedBox(width: 16),
            ],
            expandedHeight: kToolbarHeight + kSpaceBarHeight,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari batch pengiriman',
                          prefixIcon: const Icon(Icons.search_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DecoratedIconButton(
                      // onTap: () => context.push(filterPrepareGoodsRoute),
                      icon: const Icon(Icons.add_outlined),
                    ),
                  ],
                ),
              ),
            ),
            floating: true,
            snap: true,
            pinned: true,
            title: const Text('Kirim Barang'),
          ),
          if (false)
            const SliverFillRemaining(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: Center(
                  child: Text(
                    'Belum tersedia barang. Cek menu “Persiapan” untuk lanjut kirim.',
                    style: TextStyle(color: grayTertiary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemBuilder: (context, index) =>
                    BatchCardQuantityItem(batch: batch),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
              ),
            ),
        ],
      ),
    );
  }
}
