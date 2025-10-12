import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/debouncer.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/utils/states.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../../../../core/widgets/primary_gradient_card.dart';
import '../../cubit/shipment_cubit.dart';
import '../../widgets/batch_card_item.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shipmentCubit = context.read<ShipmentCubit>();
    final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    String? search;

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollState) => paginateWhenScrollEnd(
          scrollState,
          paginate: () =>
              shipmentCubit.fetchInventoriesPaginate(search: search),
        ),
        child: RefreshIndicator(
          onRefresh: shipmentCubit.fetchInventories,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: kToolbarHeight + kSpaceBarHeight + 128,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryGradientCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Jumlah Koli di Gudang',
                                  style: paragraphMedium[bold].copyWith(
                                    color: light,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                BlocBuilder<ShipmentCubit, ReusableState>(
                                  buildWhen: (previous, current) =>
                                      current is FetchShipments,
                                  builder: (context, state) {
                                    final count = state is FetchShipmentsLoaded
                                        ? state.totalAllUnits
                                        : 0;

                                    return Text(
                                      '$count',
                                      style: heading5[bold].copyWith(
                                        color: light,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                onChanged: (value) => debouncer.run(() =>
                                    shipmentCubit.fetchInventories(
                                        search: search = value)),
                                decoration: const InputDecoration(
                                  hintText: 'Cari resi atau invoice',
                                  prefixIcon: Icon(Icons.search_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            DecoratedIconButton(
                              onTap: () =>
                                  context.pushNamed(scanBarcodeInnerRoute),
                              icon: const Icon(Icons.qr_code_scanner_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                floating: true,
                pinned: true,
                snap: true,
                title: const Text('Inventory Gudang'),
              ),
              BlocBuilder<ShipmentCubit, ReusableState>(
                bloc: shipmentCubit..fetchInventories(),
                buildWhen: (previous, current) => current is FetchShipments,
                builder: (context, state) {
                  if (state is FetchShipmentsLoading) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }

                  if (state is FetchShipmentsLoaded) {
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      sliver: SliverList.separated(
                        itemBuilder: (context, index) => BatchCardItem(
                          onTap: () => context.pushNamed(
                            receiptNumbersRoute,
                            extra: {
                              'batch': state.data[index],
                              'routeDetailName': inventoryDetailRoute,
                            },
                          ),
                          batch: state.data[index],
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemCount: state.data.length,
                      ),
                    );
                  }

                  return const SliverToBoxAdapter();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
