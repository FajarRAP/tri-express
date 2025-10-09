import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../../../../core/widgets/primary_gradient_card.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../cubit/inventory_cubit.dart';
import '../../widgets/batch_card_item.dart';
import '../../widgets/shipment_receipt_numbers_bottom_sheet.dart';

class OnTheWayPage extends StatelessWidget {
  const OnTheWayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final inventoryCubit = context.read<InventoryCubit>();

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollState) {
          if (scrollState is ScrollEndNotification &&
              inventoryCubit.state is! ListPaginateLast) {
            inventoryCubit.fetchOnTheWayShipmentsPaginate();
          }

          return false;
        },
        child: RefreshIndicator(
          onRefresh: inventoryCubit.fetchOnTheWayShipments,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                actions: const <Widget>[
                  NotificationIconButton(),
                  SizedBox(width: 16),
                ],
                expandedHeight: kToolbarHeight + kSpaceBarHeight + 56,
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
                                  'Dalam Pengiriman ke ${authCubit.user.warehouse?.name}',
                                  style: paragraphMedium[bold].copyWith(
                                    color: light,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                BlocBuilder<InventoryCubit, InventoryState>(
                                  buildWhen: (previous, current) =>
                                      current is FetchOnTheWayShipments,
                                  builder: (context, state) {
                                    if (state is FetchOnTheWayShipmentsLoaded) {
                                      return Text(
                                        '${state.batches.length}',
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
                      ],
                    ),
                  ),
                ),
                floating: true,
                pinned: true,
                snap: true,
                title: const Text('On The Way'),
              ),
              BlocBuilder<InventoryCubit, InventoryState>(
                bloc: inventoryCubit..fetchOnTheWayShipments(),
                buildWhen: (previous, current) =>
                    current is FetchOnTheWayShipments,
                builder: (context, state) {
                  if (state is FetchOnTheWayShipmentsLoading) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }

                  if (state is FetchOnTheWayShipmentsLoaded) {
                    if (state.batches.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
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
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      sliver: SliverList.separated(
                        itemBuilder: (context, index) => BatchCardItem(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                ShipmentReceiptNumbersBottomSheet(
                              onSelected: (selectedGood) => context
                                  .pushNamed(onTheWayDetailRoute, extra: {
                                'batch': state.batches[index],
                                'good': selectedGood.first,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
