import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tri_express/features/inventory/presentation/cubit/inventory_cubit.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/widgets/action_confirmation_bottom_sheet.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../widgets/batch_card_action_badge_item.dart';
import '../../widgets/shipment_receipt_numbers_bottom_sheet.dart';

class PrepareGoodsPage extends StatelessWidget {
  const PrepareGoodsPage({super.key});

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
                      onTap: () => context.push(prepareGoodsFilterRoute),
                      icon: const Icon(Icons.add_outlined),
                    ),
                  ],
                ),
              ),
            ),
            floating: true,
            pinned: true,
            snap: true,
            title: const Text('Persiapan Barang'),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: lightBlue,
                ),
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Pastikan data di menu Preparation sesuai kapasitas angkutan untuk mencegah overload barang',
                  style: label[medium].copyWith(color: primaryGradientEnd),
                ),
              ),
            ),
          ),
          BlocBuilder<InventoryCubit, InventoryState>(
            bloc: inventoryCubit..fetchPrepareShipments(),
            buildWhen: (previous, current) => current is FetchPrepareShipments,
            builder: (context, state) {
              if (state is FetchPrepareShipmentsLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }

              if (state is FetchPrepareShipmentsLoaded) {
                if (state.batches.isNotEmpty) {
                  return SliverFillRemaining(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Center(
                        child: Text(
                          'Klik tombol “+” untuk mempersiapkan barang yang ingin dikirim',
                          style:
                              label[medium].copyWith(color: primaryGradientEnd),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.separated(
                    itemBuilder: (context, index) => BatchCardActionBadgeItem(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => ShipmentReceiptNumbersBottomSheet(
                          onSelected: (selectedReceiptNumbers) => context
                              .push('$itemDetailRoute/${batch.goods.first.id}'),
                          batch: batch,
                        ),
                      ),
                      onDelete: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => ActionConfirmationBottomSheet(
                          onPressed: context.pop,
                          message:
                              'Apakah anda yakin akan menghapus barang ini?',
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
