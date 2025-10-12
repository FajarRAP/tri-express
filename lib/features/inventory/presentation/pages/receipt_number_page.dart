import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/notification_icon_button.dart';
import '../../domain/entities/batch_entity.dart';
import '../cubit/receipt_number_cubit.dart';
import '../widgets/receipt_number_item.dart';

class ReceiptNumberPage extends StatelessWidget {
  const ReceiptNumberPage({
    super.key,
    required this.batch,
    required this.routeDetailName,
  });

  final BatchEntity batch;
  final String routeDetailName;

  @override
  Widget build(BuildContext context) {
    final receiptNumberCubit = context.read<ReceiptNumberCubit>();

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
                  onChanged: receiptNumberCubit.searchReceiptNumbers,
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
          BlocBuilder<ReceiptNumberCubit, ReceiptNumberState>(
            builder: (context, state) {
              if (state.goods.isEmpty) {
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
                itemBuilder: (context, index) {
                  final onTap = () => context.pushNamed(
                        routeDetailName,
                        extra: {
                          'batch': batch,
                          'good': state.goods[index],
                        },
                      );

                  return GestureDetector(
                    onTap: onTap,
                    child: ReceiptNumberItem(
                      onTap: onTap,
                      good: state.goods[index],
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: state.goods.length,
              );
            },
          ),
        ],
      ),
    );
  }
}
