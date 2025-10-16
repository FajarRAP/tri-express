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
import '../../cubit/pick_up_cubit.dart';
import '../../widgets/good_card_item.dart';

class PickUpGoodsPage extends StatefulWidget {
  const PickUpGoodsPage({super.key});

  @override
  State<PickUpGoodsPage> createState() => _PickUpGoodsPageState();
}

class _PickUpGoodsPageState extends State<PickUpGoodsPage> {
  late final PickUpCubit _pickUpCubit;
  late final Debouncer _debouncer;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _pickUpCubit = context.read<PickUpCubit>();
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
          paginate: () => _pickUpCubit.fetchPickedGoodsPaginate(
              search: _searchController.text),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            _searchController.clear();
            await _pickUpCubit.fetchPickedGoods();
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
                                _pickUpCubit.fetchPickedGoods(
                                    search: _searchController.text)),
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Cari resi atau invoice',
                              prefixIcon: const Icon(Icons.search_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DecoratedIconButton(
                          onTap: () => context.pushNamed(pickUpGoodsScanRoute),
                          icon: const Icon(Icons.add_outlined),
                        ),
                      ],
                    ),
                  ),
                ),
                floating: true,
                pinned: true,
                snap: true,
                title: const Text('Ambil di Gudang'),
              ),
              BlocBuilder<PickUpCubit, ReusableState>(
                bloc: _pickUpCubit..fetchPickedGoods(),
                buildWhen: (previous, current) => current is FetchGoods,
                builder: (context, state) {
                  if (state is FetchGoodsLoading) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }

                  if (state is FetchGoodsLoaded) {
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
                        itemBuilder: (context, index) => GoodCardItem(
                          onTap: () => context.pushNamed(
                            pickUpGoodsDetailRoute,
                            extra: state.data[index],
                          ),
                          pickedGood: state.data[index],
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemCount: state.data.length,
                      ),
                    );
                  }

                  if (state is FetchGoodsError) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Center(
                          child: Text(
                            state.failure.message,
                            style: label[medium].copyWith(
                              color: primaryGradientEnd,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
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
