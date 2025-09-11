import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../cubit/inventory_cubit.dart';
import '../../widgets/batch_card_item.dart';
import '../../widgets/shipment_receipt_numbers_bottom_sheet.dart';

class ReceiveGoodsPage extends StatelessWidget {
  const ReceiveGoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryCubit = context.read<InventoryCubit>();
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
              NotificationIconButton(),
              const SizedBox(width: 16),
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
          BlocBuilder<InventoryCubit, InventoryState>(
            bloc: inventoryCubit..fetchReceiveGoods(),
            buildWhen: (previous, current) => current is FetchReceiveGoods,
            builder: (context, state) {
              if (state is FetchReceiveGoodsLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }

              if (state is FetchReceiveGoodsLoaded) {
                if (state.batches.isNotEmpty) {
                  return SliverFillRemaining(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Center(
                        child: Text(
                          'Belum ada barang.',
                          style: label[medium].copyWith(
                            color: primaryGradientEnd,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.separated(
                    itemBuilder: (context, index) => BatchCardItem(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => ShipmentReceiptNumbersBottomSheet(
                          onSelected: (selectedReceiptNumbers) => context
                              .push('$itemDetailRoute/${batch.goods.first.id}'),
                          batch: batch,
                        ),
                      ),
                      batch: batch,
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemCount: null,
                  ),
                );
              }

              return const SliverToBoxAdapter();
            },
          ),
        ],
      ),
    );
  }
}
