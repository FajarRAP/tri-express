import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/core/presentation/cubit/core_cubit.dart';
import '../routes/router.dart';
import '../themes/colors.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final coreCubit = context.read<CoreCubit>();

    return BlocBuilder<CoreCubit, CoreState>(
      bloc: coreCubit..fetchNotifications(),
      buildWhen: (previous, current) => current is FetchNotifications,
      builder: (context, state) {
        final (void Function()? onTap, count) = switch (state) {
          final FetchNotificationsLoaded s => (
              () => context.push(notificationRoute),
              s.notifications.length
            ),
          _ => (null, 0),
        };

        return GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: graySecondary),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Badge(
              label: Text('$count'),
              child: const Icon(
                Icons.notifications_outlined,
                color: black,
              ),
            ),
          ),
        );
      },
    );
  }
}
