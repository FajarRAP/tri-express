import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/core/domain/entities/dropdown_entity.dart';
import '../../features/core/presentation/pages/home_page.dart';
import '../../features/core/presentation/pages/mobile_scanner_simple_page.dart';
import '../../features/core/presentation/pages/notification_page.dart';
import '../../features/core/presentation/pages/onboarding_page.dart';
import '../../features/core/presentation/pages/splash_page.dart';
import '../../features/inventory/domain/entities/batch_entity.dart';
import '../../features/inventory/domain/entities/good_entity.dart';
import '../../features/inventory/domain/entities/picked_good_entity.dart';
import '../../features/inventory/presentation/pages/inventory/inventory_detail_page.dart';
import '../../features/inventory/presentation/pages/inventory/inventory_page.dart';
import '../../features/inventory/presentation/pages/on_the_way/on_the_way_detail_page.dart';
import '../../features/inventory/presentation/pages/on_the_way/on_the_way_page.dart';
import '../../features/inventory/presentation/pages/pick_up_goods/pick_up_goods_confirmation_page.dart';
import '../../features/inventory/presentation/pages/pick_up_goods/pick_up_goods_detail_page.dart';
import '../../features/inventory/presentation/pages/pick_up_goods/pick_up_goods_page.dart';
import '../../features/inventory/presentation/pages/pick_up_goods/pick_up_goods_scan_page.dart';
import '../../features/inventory/presentation/pages/prepare_goods/prepare_goods_detail_page.dart';
import '../../features/inventory/presentation/pages/prepare_goods/prepare_goods_filter_page.dart';
import '../../features/inventory/presentation/pages/prepare_goods/prepare_goods_page.dart';
import '../../features/inventory/presentation/pages/prepare_goods/prepare_goods_scan_page.dart';
import '../../features/inventory/presentation/pages/receive_goods/receive_goods_detail_page.dart';
import '../../features/inventory/presentation/pages/receive_goods/receive_goods_filter_page.dart';
import '../../features/inventory/presentation/pages/receive_goods/receive_goods_page.dart';
import '../../features/inventory/presentation/pages/receive_goods/receive_goods_scan_page.dart';
import '../../features/inventory/presentation/pages/send_goods/send_goods_detail_page.dart';
import '../../features/inventory/presentation/pages/send_goods/send_goods_filter_page.dart';
import '../../features/inventory/presentation/pages/send_goods/send_goods_page.dart';
import '../../features/inventory/presentation/pages/send_goods/send_goods_scan_page.dart';
import '../../features/inventory/presentation/pages/setting_page.dart';
import '../utils/constants.dart';
import '../widgets/scaffold_with_bottom_navbar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

const onboardingRoute = '/onboarding';
const loginRoute = '/login';

const menuRoute = '/menu';
const receiveGoodsRoute = '/receive-goods';
const receiveGoodsFilterRoute = '$receiveGoodsRoute/filter';
const receiveGoodsScanRoute = '$receiveGoodsRoute/scan';
const receiveGoodsDetailRoute = '$receiveGoodsRoute/detail';
const prepareGoodsRoute = '/prepare-goods';
const prepareGoodsFilterRoute = '$prepareGoodsRoute/filter';
const prepareGoodsScanRoute = '$prepareGoodsRoute/scan';
const prepareGoodsDetailRoute = '$prepareGoodsRoute/detail';
const sendGoodsRoute = '/send-goods';
const sendGoodsFilterRoute = '$sendGoodsRoute/filter';
const sendGoodsScanRoute = '$sendGoodsRoute/scan';
const sendGoodsDetailRoute = '$sendGoodsRoute/detail';
const pickUpGoodsRoute = '/pick-up-goods';
const pickUpGoodsConfirmationRoute = '$pickUpGoodsRoute/confirmation';
const pickUpGoodsScanRoute = '$pickUpGoodsRoute/scan';
const pickUpGoodsDetailRoute = '$pickUpGoodsRoute/detail';

const onTheWayRoute = '/on-the-way';
const onTheWayDetailRoute = '/on-the-way-detail';

const inventoryRoute = '/inventory';
const inventoryDetailRoute = '/inventory-detail';

const settingRoute = '/setting';

const notificationRoute = '/notification';

const scanBarcodeRoute = '/scan-barcode';
const scanBarcodeInnerRoute = '/scan-barcode-inner';

class _GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final isScan = route.settings.name == 'scan';
    final method = isScan ? inScannablePageMethod : notInScannablePageMethod;

    platform.invokeMethod(method);
    log('didPush: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final isPrevScan = previousRoute?.settings.name == 'scan';
    final method =
        isPrevScan ? inScannablePageMethod : notInScannablePageMethod;
    platform.invokeMethod(method);
    log('didPop: ${route.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log('didRemove: $route');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    log('didReplace: $newRoute');
  }
}

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  observers: [_GoRouterObserver()],
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      observers: [_GoRouterObserver()],
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
          path: '/scan-barcode',
          builder: (context, state) => MobileScannerSimplePage(
            onDetect: (barcode) {},
          ),
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

    // Receive Goods
    GoRoute(
      path: '/receive-goods',
      builder: (context, state) => const ReceiveGoodsPage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'filter',
          builder: (context, state) => const ReceiveGoodsFilterPage(),
        ),
        GoRoute(
          path: 'scan',
          builder: (context, state) => ReceiveGoodsScanPage(
            receivedAt: state.extra as DateTime,
          ),
        ),
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final good = extras['good'] as GoodEntity;
            final batch = extras['batch'] as BatchEntity;

            return ReceiveGoodsDetailPage(
              batch: batch,
              good: good,
            );
          },
        ),
      ],
    ),
    // Prepare Goods
    GoRoute(
      path: '/prepare-goods',
      builder: (context, state) => const PrepareGoodsPage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'filter',
          builder: (context, state) => const PrepareGoodsFilterPage(),
        ),
        GoRoute(
          path: 'scan',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final shippedAt = extras['shippedAt'] as DateTime;
            final estimatedAt = extras['estimatedAt'] as DateTime;
            final nextWarehouse = extras['nextWarehouse'] as DropdownEntity;
            final transportMode = extras['transportMode'] as DropdownEntity;
            final batchName = extras['batchName'] as String;

            return PrepareGoodsScanPage(
              shippedAt: shippedAt,
              estimatedAt: estimatedAt,
              nextWarehouse: nextWarehouse,
              transportMode: transportMode,
              batchName: batchName,
            );
          },
        ),
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final good = extras['good'] as GoodEntity;
            final batch = extras['batch'] as BatchEntity;

            return PrepareGoodsDetailPage(
              batch: batch,
              good: good,
            );
          },
        ),
      ],
    ),
    // Send Goods
    GoRoute(
      path: '/send-goods',
      builder: (context, state) => const SendGoodsPage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'filter',
          builder: (context, state) => const SendGoodsFilterPage(),
        ),
        GoRoute(
          path: 'scan',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final driver = extras['driver'] as DropdownEntity;
            final nextWarehouse = extras['nextWarehouse'] as DropdownEntity;
            final deliveredAt = extras['deliveredAt'] as DateTime;

            return SendGoodsScanPage(
              driver: driver,
              nextWarehouse: nextWarehouse,
              deliveredAt: deliveredAt,
            );
          },
        ),
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final good = extras['good'] as GoodEntity;
            final batch = extras['batch'] as BatchEntity;

            return SendGoodsDetailPage(
              batch: batch,
              good: good,
            );
          },
        )
      ],
    ),
    // Pick Up Goods
    GoRoute(
      path: '/pick-up-goods',
      builder: (context, state) => const PickUpGoodsPage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'confirmation',
          builder: (context, state) => PickUpGoodsConfirmationPage(
            selectedCodes: state.extra as Map<String, Set<String>>,
            
          ),
        ),
        GoRoute(
          path: 'scan',
          builder: (context, state) => const PickUpGoodsScanPage(),
        ),
        GoRoute(
          path: 'detail',
          builder: (context, state) => PickUpGoodsDetailPage(
            pickedGood: state.extra as PickedGoodEntity,
          ),
        )
      ],
    ),

    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
        child: const SplashPage(),
      ),
    ),

    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: '/on-the-way-detail',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final batch = extras['batch'] as BatchEntity;
        final good = extras['good'] as GoodEntity;

        return OnTheWayDetailPage(
          batch: batch,
          good: good,
        );
      },
    ),

    GoRoute(
      path: '/inventory-detail',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final good = extras['good'] as GoodEntity;
        final batch = extras['batch'] as BatchEntity;

        return InventoryDetailPage(
          batch: batch,
          good: good,
        );
      },
    ),

    GoRoute(
      path: '/notification',
      builder: (context, state) => const NotificationPage(),
    ),

    GoRoute(
      path: '/scan-barcode-inner',
      builder: (context, state) =>
          MobileScannerSimplePage(onDetect: context.pop),
    ),
  ],
);
