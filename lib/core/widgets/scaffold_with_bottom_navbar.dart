import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/inventory/presentation/cubit/inventory_cubit.dart';
import '../../features/inventory/presentation/widgets/unique_code_action_bottom_sheet.dart';
import '../routes/router.dart';
import '../themes/colors.dart';
import '../utils/top_snackbar.dart';

class ScaffoldWithBottomNavbar extends StatelessWidget {
  const ScaffoldWithBottomNavbar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => _onItemTapped(index, context),
        currentIndex: getIndex(context),
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Menu',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            label: 'On The Way',
          ),
          BottomNavigationBarItem(
            icon: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: primary,
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(
                Icons.qr_code_scanner_outlined,
                color: light,
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Inventory',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
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

    if (path.startsWith(menuRoute)) return 0;
    if (path.startsWith(onTheWayRoute)) return 1;
    if (path.startsWith(inventoryRoute)) return 3;
    if (path.startsWith(settingRoute)) return 4;

    return 0;
  }
}

class _UniqueCodeActionBuilder extends StatelessWidget {
  const _UniqueCodeActionBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryCubit, InventoryState>(
      buildWhen: (previous, current) => current is FetchLostGood,
      listener: (context, state) {
        if (state is FetchLostGoodLoaded) {
          context.pushNamed(lostGoodRoute, extra: state.lostGood);
        }

        if (state is FetchLostGoodError) {
          TopSnackbar.dangerSnackbar(message: state.message);
        }
      },
      builder: (context, state) {
        final onResult = switch (state) {
          FetchLostGoodLoading() => null,
          _ => (String value) =>
              context.read<InventoryCubit>().fetchLostGoods(uniqueCode: value)
        };

        return UniqueCodeActionBottomSheet(
          onResult: onResult,
        );
      },
    );
  }
}
