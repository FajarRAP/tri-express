import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/router.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../widgets/batch_card_item.dart';
import '../../widgets/shipment_receipt_numbers_bottom_sheet.dart';

class ReceiveGoodsPage extends StatelessWidget {
  const ReceiveGoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
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
                          hintText: 'Cari resi atau invoice',
                          prefixIcon: const Icon(Icons.search_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    DecoratedIconButton(
                      onTap: () => context.push(filterReceiveGoodsRoute),
                      icon: const Icon(Icons.add_outlined),
                    ),
                  ],
                ),
              ),
            ),
            floating: true,
            pinned: true,
            snap: true,
            title: const Text('Terima Barang'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemBuilder: (context, index) => BatchCardItem(
                  onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => ShipmentReceiptNumbersBottomSheet(
                          onSelected: (selectedReceiptNumbers) {
                            debugPrint(
                                'Selected Receipt Numbers: $selectedReceiptNumbers');
                            context.push(
                                '$receiveGoodsRoute$itemDetailRoute/${batch.goods.first.id}');
                          },
                          batch: batch,
                        ),
                      ),
                  batch: batch),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
          )
        ],
      ),
    );
  }
}
