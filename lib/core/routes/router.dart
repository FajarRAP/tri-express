import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/inventory/presentation/pages/batch_detail_page.dart';
import '../../features/inventory/presentation/pages/filter_received_goods_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/inventory/presentation/pages/item_detail_page.dart';
import '../../features/inventory/presentation/pages/on_the_way_page.dart';
import '../../features/inventory/presentation/pages/prepare_goods/prepare_goods_add_item_page.dart';
import '../../features/inventory/presentation/pages/prepare_goods/prepare_goods_filter_page.dart';
import '../../features/inventory/presentation/pages/prepare_goods/prepare_goods_page.dart';
import '../../features/inventory/presentation/pages/receive_goods_page.dart';
import '../../features/inventory/presentation/pages/received_goods_page.dart';
import '../../features/inventory/presentation/pages/send_goods/send_goods_add_item_page.dart';
import '../../features/inventory/presentation/pages/send_goods/send_goods_filter_page.dart';
import '../../features/inventory/presentation/pages/send_goods/send_goods_page.dart';
import '../../features/inventory/presentation/pages/setting_page.dart';
import '../pages/home_page.dart';
import '../pages/onboarding_page.dart';
import '../utils/constants.dart';
import '../widgets/scaffold_with_bottom_navbar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

const onboardingRoute = '/onboarding';
const loginRoute = '/login';

const menuRoute = '/menu';
const receivedGoodsRoute = '$menuRoute/received-goods';
const filterReceivedGoodsRoute = '$receivedGoodsRoute/filter';
const receiveGoodsRoute = '$receivedGoodsRoute/receive';
const prepareGoodsRoute = '$menuRoute/prepare-goods';
const filterPrepareGoodsRoute = '$prepareGoodsRoute/filter';
const prepareGoodsAddItemRoute = '$prepareGoodsRoute/add-item';
const sendGoodsRoute = '$menuRoute/send-goods';
const sendGoodsFilterRoute = '$sendGoodsRoute/filter';
const sendGoodsAddItemRoute = '$sendGoodsRoute/add-items';

const onTheWayRoute = '/on-the-way';
const batchDetailRoute = '/batch-detail';
const itemDetailRoute = '/item';

const inventoryRoute = '/inventory';

const settingRoute = '/setting';

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: onboardingRoute,
  redirect: (context, state) {
    scannablePage.contains(state.uri.path)
        ? platform.invokeMethod<bool>(inScannablePageMethod)
        : platform.invokeMethod<bool>(notInScannablePageMethod);

    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) =>
          ScaffoldWithBottomNavbar(child: child),
      routes: <RouteBase>[
        GoRoute(
          path: '/menu',
          builder: (context, state) => const HomePage(),
          routes: <RouteBase>[
            GoRoute(
              path: 'received-goods',
              builder: (context, state) => const ReceivedGoodsPage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'filter',
                  builder: (context, state) => const FilterReceivedGoodsPage(),
                ),
                GoRoute(
                  path: 'receive',
                  builder: (context, state) => const ReceiveGoodsPage(),
                ),
              ],
            ),
            GoRoute(
              path: 'prepare-goods',
              builder: (context, state) => const PrepareGoodsPage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'filter',
                  builder: (context, state) => const FilterPrepareGoodsPage(),
                ),
                GoRoute(
                  path: 'add-item',
                  builder: (context, state) => PrepareGoodsAddItemPage(
                    batchName: '${state.extra}',
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'send-goods',
              builder: (context, state) => const SendGoodsPage(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'filter',
                  builder: (context, state) => const SendGoodsFilterPage(),
                ),
                GoRoute(
                  path: 'add-items',
                  builder: (context, state) => const SendGoodsAddItemPage(),
                ),
              ],
            ),
          ],
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
