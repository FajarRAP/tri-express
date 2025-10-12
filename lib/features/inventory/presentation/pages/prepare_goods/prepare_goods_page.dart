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
import '../../../../../core/utils/top_snackbar.dart';
import '../../../../../core/widgets/action_confirmation_bottom_sheet.dart';
import '../../../../../core/widgets/decorated_icon_button.dart';
import '../../../../../core/widgets/notification_icon_button.dart';
import '../../cubit/prepare_cubit.dart';
import '../../widgets/batch_card_action_badge_item.dart';

class PrepareGoodsPage extends StatelessWidget {
  const PrepareGoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prepareCubit = context.read<PrepareCubit>();
    final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    String? search;

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollState) => paginateWhenScrollEnd(
          scrollState,
          paginate: () =>
              prepareCubit.fetchPrepareShipmentsPaginate(search: search),
        ),
        child: RefreshIndicator(
          onRefresh: prepareCubit.fetchPrepareShipments,
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
                                prepareCubit.fetchPrepareShipments(
                                    search: search = value)),
                            decoration: const InputDecoration(
                              hintText: 'Cari resi atau invoice',
                              prefixIcon: const Icon(Icons.search_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DecoratedIconButton(
                          onTap: () =>
                              context.pushNamed(prepareGoodsFilterRoute),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
              BlocConsumer<PrepareCubit, ReusableState<List>>(
                bloc: prepareCubit..fetchPrepareShipments(),
                buildWhen: (previous, current) => current is FetchShipments,
                listener: (context, state) {
                  if (state is ActionSuccess<List>) {
                    TopSnackbar.successSnackbar(message: state.message);
                    context.pop();
                    prepareCubit.fetchPrepareShipments();
                  }

                  if (state is ActionFailure<List>) {
                    TopSnackbar.dangerSnackbar(message: state.failure.message);
                  }
                },
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
                              'Klik tombol “+” untuk mempersiapkan barang yang ingin dikirim',
                              style: label[medium]
                                  .copyWith(color: primaryGradientEnd),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList.separated(
                        itemBuilder: (context, index) =>
                            BatchCardActionBadgeItem(
                          onTap: () => context.pushNamed(
                            receiptNumbersRoute,
                            extra: {
                              'batch': state.data[index],
                              'routeDetailName': prepareGoodsDetailRoute,
                            },
                          ),
                          onDelete: () => showModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                BlocBuilder<PrepareCubit, ReusableState<List>>(
                              buildWhen: (previous, current) =>
                                  current is ActionState,
                              builder: (context, deleteState) {
                                final onPressed = switch (deleteState) {
                                  ActionInProgress() => null,
                                  _ => () =>
                                      prepareCubit.deletePreparedShipments(
                                          shipmentId: state.data[index].id),
                                };

                                return ActionConfirmationBottomSheet(
                                  onPressed: onPressed,
                                  message:
                                      'Apakah anda yakin akan menghapus barang ini?',
                                );
                              },
                            ),
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
