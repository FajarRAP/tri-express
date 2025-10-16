import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/inventory/domain/entities/lost_good_entity.dart';
import '../../features/inventory/presentation/cubit/shipment_cubit.dart';
import '../../features/inventory/presentation/widgets/unique_code_action_bottom_sheet.dart';
import '../routes/router.dart';
import '../themes/colors.dart';
import '../utils/constants.dart';
import '../utils/states.dart';
import '../utils/top_snackbar.dart';

class ScaffoldWithBottomNavbar extends StatelessWidget {
  const ScaffoldWithBottomNavbar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current is UpdateUser,
      listener: (context, state) {
        if (state is UpdateUserError) {
          TopSnackbar.dangerSnackbar(message: state.message);
        }

        if (state is UpdateUserLoaded) {
          TopSnackbar.successSnackbar(message: state.message);
          context.read<AuthCubit>().fetchCurrentUser();
        }
      },
      builder: (context, state) {
        final scaffold = Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) => _onItemTapped(index, context),
            currentIndex: getIndex(context),
            unselectedItemColor: black,
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            selectedItemColor: primary,
            selectedLabelStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                activeIcon: _Icon(path: homeSvgPath, isActive: true),
                icon: _Icon(path: homeSvgPath),
                label: 'Menu',
              ),
              const BottomNavigationBarItem(
                activeIcon: _Icon(path: truckAltSvgPath, isActive: true),
                icon: _Icon(path: truckAltSvgPath),
                label: 'On The Way',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primary,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    qrScannerSvgPath,
                    colorFilter: const ColorFilter.mode(light, BlendMode.srcIn),
                  ),
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                activeIcon: _Icon(path: boxAltSvgPath, isActive: true),
                icon: _Icon(path: boxAltSvgPath),
                label: 'Inventory',
              ),
              const BottomNavigationBarItem(
                activeIcon: _Icon(path: settingSvgPath, isActive: true),
                icon: _Icon(path: settingSvgPath),
                label: 'Settings',
              ),
            ],
          ),
        );
        final scaffoldWithLoading = Stack(
          children: [
            scaffold,
            Container(
              alignment: Alignment.center,
              color: gray.withValues(alpha: .5),
              child: const CircularProgressIndicator.adaptive(),
            )
          ],
        );

        return state is UpdateUserLoading ? scaffoldWithLoading : scaffold;
      },
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(menuRoute);
      case 1:
        context.goNamed(onTheWayRoute);
      case 2:
        showModalBottomSheet(
          context: context,
          builder: (context) => const _UniqueCodeActionBuilder(),
        );
      case 3:
        context.goNamed(inventoryRoute);
      case 4:
        context.goNamed(settingRoute);
    }
  }

  static int getIndex(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    if (path.startsWith('/$menuRoute')) return 0;
    if (path.startsWith('/$onTheWayRoute')) return 1;
    if (path.startsWith('/$inventoryRoute')) return 3;
    if (path.startsWith('/$settingRoute')) return 4;

    return 0;
  }
}

class _UniqueCodeActionBuilder extends StatelessWidget {
  const _UniqueCodeActionBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShipmentCubit, ReusableState>(
      listener: (context, state) {
        if (state is Loaded<LostGoodEntity>) {
          context.pushNamed(lostGoodRoute, extra: state.data);
        }

        if (state is Error<LostGoodEntity>) {
          TopSnackbar.dangerSnackbar(message: state.failure.message);
        }
      },
      builder: (context, state) {
        final onResult = switch (state) {
          Loading<LostGoodEntity>() => null,
          _ => context.read<ShipmentCubit>().fetchLostGoods
        };

        return UniqueCodeActionBottomSheet(onResult: onResult);
      },
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon({
    required this.path,
    this.isActive = false,
  });

  final String path;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      colorFilter:
          isActive ? const ColorFilter.mode(primary, BlendMode.srcIn) : null,
      width: 24,
    );
  }
}
