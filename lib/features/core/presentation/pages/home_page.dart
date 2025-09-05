import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/notification_icon_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/core_cubit.dart';
import '../widgets/action_card.dart';
import '../widgets/data_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final coreCubit = context.read<CoreCubit>();

    return SafeArea(
      child: BlocBuilder<AuthCubit, AuthState>(
        bloc: authCubit..fetchCurrentUser(),
        builder: (context, state) {
          if (state is FetchCurrentUserLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (state is FetchCurrentUserLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 24,
                      foregroundImage: state.user.avatarUrl != null
                          ? NetworkImage(state.user.avatarUrl!)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          state.user.name,
                          style: const TextStyle(
                            color: black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (!state.user.roles.contains(superAdminRole))
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Icon(
                                Icons.location_pin,
                                color: grayTertiary,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Warehouse Location',
                                style: const TextStyle(
                                  color: grayTertiary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  ],
                ),
                actions: <Widget>[
                  const NotificationIconButton(),
                  const SizedBox(width: 16),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: <Widget>[
                  const SizedBox(height: 24),
                  BlocConsumer<CoreCubit, CoreState>(
                    bloc: coreCubit..fetchSummary(),
                    buildWhen: (previous, current) => current is FetchSummary,
                    listener: (context, state) {
                      if (state is FetchSummaryError) {
                        TopSnackbar.dangerSnackbar(message: state.message);
                      }
                    },
                    builder: (context, state) {
                      if (state is FetchSummaryLoading) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }

                      if (state is FetchSummaryLoaded) {
                        return Row(
                          children: <Widget>[
                            Expanded(
                              child: DataCard(
                                icon: Icons.local_shipping_outlined,
                                label: 'On the way',
                                number: state.summary[0],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DataCard(
                                icon: Icons.inventory_2_outlined,
                                label: 'Koli diterima',
                                number: state.summary[1],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DataCard(
                                icon: Icons.send_outlined,
                                label: 'Koli terkirim',
                                number: state.summary[2],
                              ),
                            ),
                          ],
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: BlocBuilder<CoreCubit, CoreState>(
                      bloc: coreCubit..fetchBanners(),
                      buildWhen: (previous, current) => current is FetchBanners,
                      builder: (context, state) {
                        if (state is FetchBannersLoading) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }

                        if (state is FetchBannersLoaded) {
                          return CarouselView.weighted(
                            enableSplash: false,
                            flexWeights: [1],
                            itemSnapping: true,
                            children: state.banners
                                .map((banner) =>
                                    Image.network(banner, fit: BoxFit.cover))
                                .toList(),
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Silakan Tentukan Apa yang Ingin Anda Lakukan',
                    style: TextStyle(
                      color: black,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[
                      ActionCard(
                        onTap: () => context.push(receivedGoodsRoute),
                        icon: Icons.inventory_2_outlined,
                        title: 'Terima Barang',
                      ),
                      ActionCard(
                        onTap: () => context.push(prepareGoodsRoute),
                        icon: Icons.inventory_2_outlined,
                        title: 'Persiapan Barang',
                      ),
                      ActionCard(
                        onTap: () => context.push(sendGoodsRoute),
                        icon: Icons.inventory_2_outlined,
                        title: 'Kirim Barang',
                      ),
                      ActionCard(
                        icon: Icons.inventory_2_outlined,
                        title: 'Ambil di Gudang',
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
