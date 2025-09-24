import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/widgets/decorated_icon_button.dart';
import '../../../../core/widgets/primary_gradient_card.dart';
import '../cubit/inventory_cubit.dart';
import '../widgets/batch_card_item.dart';
import '../widgets/shipment_receipt_numbers_bottom_sheet.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inventoryCubit = context.read<InventoryCubit>();
    final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    String? search;

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollState) {
          if (scrollState is ScrollEndNotification &&
              inventoryCubit.state is! ListPaginateLast) {
            inventoryCubit.fetchInventoriesPaginate(search: search);
          }

          return false;
        },
        child: RefreshIndicator(
          onRefresh: inventoryCubit.fetchInventories,
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
                                BlocBuilder<InventoryCubit, InventoryState>(
                                  bloc: inventoryCubit..fetchInventoriesCount(),
                                  buildWhen: (previous, current) =>
                                      current is FetchInventoriesCount,
                                  builder: (context, state) {
                                    if (state is FetchInventoriesCountLoaded) {
                                      return Text(
                                        '${state.count}',
                                        style: heading5[bold].copyWith(
                                          color: light,
                                        ),
                                      );
                                    }

                                    return Text(
                                      '...',
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
                                    inventoryCubit.fetchInventories(
                                        search: search = value)),
                                decoration: const InputDecoration(
                                  hintText: 'Cari resi atau invoice',
                                  prefixIcon: Icon(Icons.search_outlined),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            DecoratedIconButton(
                              onTap: () => context.push(scanBarcodeInnerRoute),
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
              BlocBuilder<InventoryCubit, InventoryState>(
                bloc: inventoryCubit..fetchInventories(),
                buildWhen: (previous, current) => current is FetchInventories,
                builder: (context, state) {
                  if (state is FetchInventoriesLoading) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }

                  if (state is FetchInventoriesLoaded) {
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      sliver: SliverList.separated(
                        itemBuilder: (context, index) => BatchCardItem(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                ShipmentReceiptNumbersBottomSheet(
                              onSelected: (selectedGood) =>
                                  context.push(inventoryDetailRoute, extra: {
                                'good': selectedGood.first,
                                'batch': state.batches[index],
                              }),
                              batch: state.batches[index],
                            ),
                          ),
                          batch: state.batches[index],
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemCount: state.batches.length,
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
