import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/top_snackbar.dart';
import '../cubit/core_cubit.dart';
import '../widgets/notification_item.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final coreCubit = context.read<CoreCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: BlocBuilder<CoreCubit, CoreState>(
        bloc: coreCubit..fetchNotifications(),
        buildWhen: (previous, current) => current is FetchNotifications,
        builder: (context, state) {
          if (state is FetchNotificationsLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (state is FetchNotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Text(
                  'Belum ada notifikasi.',
                  style: label[medium].copyWith(color: primaryGradientEnd),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: BlocConsumer<CoreCubit, CoreState>(
                        buildWhen: (previous, current) =>
                            current is ReadAllNotifications,
                        listener: (context, state) {
                          if (state is ReadAllNotificationsLoaded) {
                            coreCubit.fetchNotifications();
                            TopSnackbar.successSnackbar(message: state.message);
                          }

                          if (state is ReadAllNotificationsError) {
                            TopSnackbar.dangerSnackbar(message: state.message);
                          }
                        },
                        builder: (context, state) {
                          final onPressed = switch (state) {
                            ReadAllNotificationsLoading() => null,
                            _ => coreCubit.readAllNotifications
                          };

                          return TextButton(
                            onPressed: onPressed,
                            child: const Text('Tandai semua telah dibaca'),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 16),
                    sliver: SliverList.separated(
                      itemBuilder: (context, index) => NotificationItem(
                        notification: state.notifications[index],
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: state.notifications.length,
                    ),
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
