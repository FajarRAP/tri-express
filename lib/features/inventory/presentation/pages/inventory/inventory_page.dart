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
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../../../../core/widgets/primary_gradient_card.dart';
import '../../cubit/shipment_cubit.dart';
import '../../widgets/inventory_item.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late final ShipmentCubit _shipmentCubit;
  late final Debouncer _debouncer;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _shipmentCubit = context.read<ShipmentCubit>()..fetchInventories();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollState) => paginateWhenScrollEnd(
          scrollState,
          paginate: () => _shipmentCubit.fetchInventoriesPaginate(
              search: _searchController.text),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            _searchController.clear();
            await _shipmentCubit.fetchInventories();
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                actions: const <Widget>[
                  NotificationIconButton(),
                  SizedBox(width: 16),
                ],
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
                                      current is FetchInventories,
                                  builder: (context, state) {
                                    final count =
                                        state is FetchInventoriesLoaded
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
                                onChanged: (value) => _debouncer.run(() =>
                                    _shipmentCubit.fetchInventories(
                                        search: value)),
                                controller: _searchController,
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
                leading: IconButton(
                  onPressed: () => context.goNamed(menuRoute),
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Back',
                ),
                pinned: true,
                snap: true,
                title: const Text('Inventory Gudang'),
              ),
              BlocBuilder<ShipmentCubit, ReusableState>(
                bloc: _shipmentCubit,
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
                        itemBuilder: (context, index) => InventoryItem(
                          lostGood: state.data[index],
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
