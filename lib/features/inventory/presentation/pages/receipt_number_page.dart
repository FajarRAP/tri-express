import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/notification_icon_button.dart';
import '../../domain/entities/batch_entity.dart';
import '../../domain/entities/good_entity.dart';
import '../cubit/inventory_cubit.dart';

class ReceiptNumberPage extends StatelessWidget {
  const ReceiptNumberPage({
    super.key,
    required this.batch,
  });

  final BatchEntity batch;

  @override
  Widget build(BuildContext context) {
    final inventoryCubit = context.read<InventoryCubit>();

    return Scaffold(
      body: CustomScrollView(
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
                child: TextField(
                  onChanged: (value) =>
                      inventoryCubit.searchReceiptNumbers(batch, value),
                  decoration: const InputDecoration(
                    hintText: 'Cari resi',
                    prefixIcon: Icon(Icons.search_outlined),
                  ),
                ),
              ),
            ),
            floating: true,
            pinned: true,
            snap: true,
            title: Text(batch.name),
          ),
          BlocBuilder<InventoryCubit, InventoryState>(
            bloc: inventoryCubit..searchReceiptNumbers(batch),
            buildWhen: (previous, current) =>
                current is ReceiptNumberSearchableState,
            builder: (context, state) {
              final goods = state is ReceiptNumberSearchableState
                  ? state.goods
                  : <GoodEntity>[];

              if (goods.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Center(
                      child: Text(
                        'Nomor resi tidak ditemukan',
                        style:
                            label[medium].copyWith(color: primaryGradientEnd),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }

              return SliverList.separated(
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => context.pushNamed(
                    receiveGoodsDetailRoute,
                    extra: {
                      'batch': batch,
                      'good': goods[index],
                    },
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: graySecondary),
                      borderRadius: BorderRadius.circular(10),
                      color: light,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: primary50,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            boxSvgPath,
                            colorFilter: const ColorFilter.mode(
                              primary,
                              BlendMode.srcIn,
                            ),
                            width: 20,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          goods[index].receiptNumber,
                          style: label[bold].copyWith(color: black),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.pushNamed(
                            receiveGoodsDetailRoute,
                            extra: {
                              'batch': batch,
                              'good': goods[index],
                            },
                          ),
                          child: const Text('Lihat Detail'),
                        ),
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: goods.length,
              );
            },
          ),
        ],
      ),
    );
  }
}
