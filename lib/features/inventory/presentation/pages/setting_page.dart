import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/base_card.dart';
import '../../../../core/widgets/buttons/danger_button.dart';
import '../../../../core/widgets/notification_icon_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            const CircleAvatar(radius: 24),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'User Name',
                  style: const TextStyle(
                    color: black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
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
                ),
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
          Text(
            'Pengaturan',
            style: const TextStyle(
              color: black,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Konfigurasi Inventory',
                  style: const TextStyle(
                    color: black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Mode Inventory',
                  style: const TextStyle(
                    color: black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: 'Pilih mode inventory',
                  ),
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value: 'mode1',
                      child: Text('Mode 1'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'mode2',
                      child: Text('Mode 2'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Mode RF',
                  style: const TextStyle(
                    color: black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: 'Pilih mode RF',
                  ),
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value: 'mode1',
                      child: Text('Mode 1'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'mode2',
                      child: Text('Mode 2'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CheckboxListTile.adaptive(
                  onChanged: (value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Read TID (hanya muncul saat mode = Normal Inventory)',
                    style: const TextStyle(
                      color: black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  value: false,
                ),
                const SizedBox(height: 10),
                Text(
                  'Item untuk Fast Model',
                  style: const TextStyle(
                    color: black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                CheckboxListTile.adaptive(
                  onChanged: (value) {},
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    'RSSI',
                    style: const TextStyle(
                      color: black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  value: false,
                ),
                CheckboxListTile.adaptive(
                  onChanged: (value) {},
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    'Frequency',
                    style: const TextStyle(
                      color: black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  value: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          BaseCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Session & Target Behavior',
                  style: const TextStyle(
                    color: black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Session',
                  style: const TextStyle(
                    color: black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: 'Pilih session',
                  ),
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value: 'session1',
                      child: Text('Session 1'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'session2',
                      child: Text('Session 2'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Target',
                  style: const TextStyle(
                    color: black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: 'Pilih target',
                  ),
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value: 'target1',
                      child: Text('Target 1'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'target2',
                      child: Text('Target 2'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          BlocConsumer<AuthCubit, AuthState>(
            buildWhen: (previous, current) => current is Logout,
            listenWhen: (previous, current) => current is Logout,
            listener: (context, state) {
              if (state is LogoutLoaded) {
                TopSnackbar.successSnackbar(message: state.message);
                context.go(loginRoute);
              }
              if (state is LogoutError) {
                TopSnackbar.dangerSnackbar(message: state.message);
              }
            },
            builder: (context, state) {
              if (state is LogoutLoading) {
                return const DangerButton(
                  child: Text('Logout'),
                );
              }

              return DangerButton(
                onPressed: authCubit.logout,
                child: const Text('Logout'),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
