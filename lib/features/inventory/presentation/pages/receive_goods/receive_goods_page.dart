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
import '../../../domain/entities/batch_entity.dart';
import '../../cubit/receive_cubit.dart';
import '../../widgets/batch_card_item.dart';

class ReceiveGoodsPage extends StatelessWidget {
  const ReceiveGoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final receiveCubit = context.read<ReceiveCubit>();
    final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    String? search;

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) => paginateWhenScrollEnd(
          notification,
          paginate: () =>
              receiveCubit.fetchReceiveShipmentsPaginate(search: search),
        ),
        child: RefreshIndicator(
          onRefresh: receiveCubit.fetchReceiveShipments,
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
                        Expanded(
                          child: TextField(
                            onChanged: (value) => debouncer.run(() =>
                                receiveCubit.fetchReceiveShipments(
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
                              context.pushNamed(receiveGoodsFilterRoute),
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
              BlocBuilder<ReceiveCubit, ReusableState>(
                bloc: receiveCubit..fetchReceiveShipments(),
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
                              'routeDetailName': receiveGoodsDetailRoute,
                            },
                          ),
                          batch: state.data[index],
                          quantity: _renderQuantity(state.data[index]),
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

  Widget _renderQuantity(BatchEntity batch) {
    if (batch.receivedUnits < batch.totalAllUnits) {
      return RichText(
        text: TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: '${batch.receivedUnits}',
              style: label[regular].copyWith(color: black),
            ),
            TextSpan(
              text: '/${batch.totalAllUnits} Koli',
              style: label[bold].copyWith(color: black),
            ),
          ],
        ),
      );
    }

    return Text(
      '${batch.totalAllUnits} Koli',
      style: label[bold].copyWith(color: black),
    );
  }
}
