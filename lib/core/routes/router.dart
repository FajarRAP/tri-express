import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/inventory/presentation/pages/batch_detail_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/inventory/presentation/pages/item_detail_page.dart';
import '../../features/inventory/presentation/pages/on_the_way_page.dart';
import '../../features/inventory/presentation/pages/setting_page.dart';
import '../pages/home_page.dart';
import '../widgets/scaffold_with_bottom_navbar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

const menuRoute = '/menu';

const onTheWayRoute = '/on-the-way';
const batchDetailRoute = '/batch-detail';
const itemDetailRoute = '/item';

const inventoryRoute = '/inventory';

const settingRoute = '/setting';

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: menuRoute,
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) =>
          ScaffoldWithBottomNavbar(child: child),
      routes: <RouteBase>[
        GoRoute(
          path: '/menu',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/on-the-way',
          builder: (context, state) => const OnTheWayPage(),
          routes: <RouteBase>[
            GoRoute(
              path: 'batch-detail/:batchId',
              builder: (context, state) => BatchDetailPage(
                batchId: '${state.pathParameters['batchId']}',
                title: '${state.extra}',
              ),
              routes: <RouteBase>[
                GoRoute(
                  path: 'item/:itemId',
                  builder: (context, state) => ItemDetailPage(
                    itemId: '${state.pathParameters['itemId']}',
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/third',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/inventory',
          builder: (context, state) => const InventoryPage(),
        ),
        GoRoute(
          path: '/setting',
          builder: (context, state) => const SettingPage(),
        ),
      ],
    ),
  ],
);
