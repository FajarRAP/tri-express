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
import '../../cubit/delivery_cubit.dart';
import '../../widgets/batch_card_item.dart';

class SendGoodsPage extends StatefulWidget {
  const SendGoodsPage({super.key});

  @override
  State<SendGoodsPage> createState() => _SendGoodsPageState();
}

class _SendGoodsPageState extends State<SendGoodsPage> {
  late final DeliveryCubit _deliveryCubit;
  late final Debouncer _debouncer;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _deliveryCubit = context.read<DeliveryCubit>()..fetchDeliveryShipments();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollState) => paginateWhenScrollEnd(
          scrollState,
          paginate: () => _deliveryCubit.fetchDeliveryShipmentsPaginate(
              search: _searchController.text),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            _searchController.clear();
            await _deliveryCubit.fetchDeliveryShipments();
          },
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
                            onChanged: (value) => _debouncer.run(() =>
                                _deliveryCubit.fetchDeliveryShipments(
                                    search: _searchController.text)),
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Cari batch pengiriman',
                              prefixIcon: Icon(Icons.search_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DecoratedIconButton(
                          onTap: () => context.pushNamed(sendGoodsFilterRoute),
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
              BlocBuilder<DeliveryCubit, ReusableState<List<BatchEntity>>>(
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
                              'Belum tersedia barang. Cek menu “Persiapan” untuk lanjut kirim.',
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
                              'routeDetailName': sendGoodsDetailRoute,
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
