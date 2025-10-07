import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Tandai semua telah dibaca'),
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
