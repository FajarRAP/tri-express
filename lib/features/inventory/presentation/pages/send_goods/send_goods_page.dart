import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/router.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../cubit/inventory_cubit.dart';
import '../../widgets/batch_card_item.dart';
import '../../widgets/shipment_receipt_numbers_bottom_sheet.dart';

class SendGoodsPage extends StatelessWidget {
  const SendGoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryCubit = context.read<InventoryCubit>();

    return Scaffold(
      body: BlocBuilder<InventoryCubit, InventoryState>(
        bloc: inventoryCubit..fetchDeliveryShipments(),
        buildWhen: (previous, current) => current is FetchDeliveryShipments,
        builder: (context, state) {
          if (state is FetchDeliveryShipmentsLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (state is FetchDeliveryShipmentsLoaded) {
            if (state.batches.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: Center(
                  child: Text(
                    'Belum tersedia barang. Cek menu “Persiapan” untuk lanjut kirim.',
                    style: TextStyle(color: grayTertiary),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: inventoryCubit.fetchDeliveryShipments,
              child: CustomScrollView(
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
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Cari batch pengiriman',
                                  prefixIcon: const Icon(Icons.search_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            DecoratedIconButton(
                              onTap: () => context.push(sendGoodsFilterRoute),
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
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverList.separated(
                      itemBuilder: (context, index) => BatchCardItem(
                        onTap: () => showModalBottomSheet(
                          builder: (context) =>
                              ShipmentReceiptNumbersBottomSheet(
                            onSelected: (selectedReceiptNumbers) => context.push(
                                '$itemDetailRoute/${selectedReceiptNumbers.first}'),
                            batch: batch,
                          ),
                          backgroundColor: light,
                          context: context,
                        ),
                        batch: state.batches[index],
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: state.batches.length,
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
