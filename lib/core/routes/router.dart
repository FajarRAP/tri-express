import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/inventory/presentation/pages/on_the_way_page.dart';
import '../pages/home_page.dart';
import '../widgets/scaffold_with_bottom_navbar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

const menuPage = '/menu';
const onTheWayPage = '/on-the-way';

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: menuPage,
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
        ),
        GoRoute(
          path: '/third',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/fourth',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/fifth',
          builder: (context, state) => const HomePage(),
        ),
      ],
    ),
  ],
);
