import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/router.dart';
import '../themes/colors.dart';

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
        selectedItemColor: primary,
        selectedLabelStyle: const TextStyle(
          color: primary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
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
              child: Icon(
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
        context.go(menuPage);
      case 1:
        context.go(onTheWayPage);
      case 2:
        context.go('/third');
      case 3:
        context.go('/fourth');
      case 4:
        context.go('/fifth');
    }
  }

  static int getIndex(BuildContext context) {
    final selectedIndex = GoRouterState.of(context).uri.path;

    switch (selectedIndex) {
      case menuPage:
        return 0;
      case onTheWayPage:
        return 1;
      case '/third':
        return 2;
      case '/fourth':
        return 3;
      case '/fifth':
        return 4;
      default:
        return 0;
    }
  }
}
