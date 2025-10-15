import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/fonts/fonts.dart';
import '../../../../../core/routes/router.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/utils/states.dart';
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../../../../core/widgets/primary_gradient_card.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../cubit/shipment_cubit.dart';
import '../../widgets/batch_card_item.dart';

class OnTheWayPage extends StatelessWidget {
  const OnTheWayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final shipmentCubit = context.read<ShipmentCubit>();

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollState) => paginateWhenScrollEnd(
          scrollState,
          paginate: shipmentCubit.fetchOnTheWayShipmentsPaginate,
        ),
        child: RefreshIndicator(
          onRefresh: shipmentCubit.fetchOnTheWayShipments,
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
                                BlocBuilder<ShipmentCubit, ReusableState>(
                                  buildWhen: (previous, current) =>
                                      current is FetchShipments,
                                  builder: (context, state) {
                                    final count = switch (state) {
                                      final FetchShipmentsLoaded s =>
                                        s.data.length,
                                      _ => 0,
                                    };

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
                title: const Text('On The Way'),
              ),
              BlocBuilder<ShipmentCubit, ReusableState>(
                bloc: shipmentCubit..fetchOnTheWayShipments(),
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
                    if (state.data.isEmpty) {
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
                          onTap: () => context.pushNamed(
                            receiptNumbersRoute,
                            extra: {
                              'batch': state.data[index],
                              'routeDetailName': onTheWayDetailRoute,
                            },
                          ),
                          batch: state.data[index],
                          quantity: Text(
                            '${state.data[index].totalAllUnits - state.data[index].receivedUnits} Koli',
                            style: label[bold].copyWith(color: black),
                          ),
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemCount: state.data.length,
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
