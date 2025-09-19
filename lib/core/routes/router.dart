import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/core/presentation/pages/home_page.dart';
import '../../features/core/presentation/pages/mobile_scanner_simple_page.dart';
import '../../features/core/presentation/pages/notification_page.dart';
import '../../features/core/presentation/pages/onboarding_page.dart';
import '../../features/inventory/domain/entities/batch_entity.dart';
import '../../features/inventory/domain/entities/good_entity.dart';
import '../../features/inventory/domain/entities/warehouse_entity.dart';
import '../../features/inventory/presentation/pages/inventory_detail_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/inventory/presentation/pages/item_detail_page.dart';
import '../../features/inventory/presentation/pages/on_the_way_detail_page.dart';
import '../../features/inventory/presentation/pages/on_the_way_page.dart';
import '../../features/inventory/presentation/pages/pick_up_goods/pick_up_goods_confirmation_page.dart';
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

late final String initialLocation;

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

const onTheWayRoute = '/on-the-way';
const onTheWayDetailRoute = '/on-the-way-detail';
const batchDetailRoute = '/batch-detail';
const itemDetailRoute = '/item-detail';

const inventoryRoute = '/inventory';
const inventoryDetailRoute = '/inventory-detail';

const settingRoute = '/setting';

const notificationRoute = '/notification';

const scanBarcodeRoute = '/scan-barcode';
const scanBarcodeInnerRoute = '/scan-barcode-inner';

class GoRouterObserver extends NavigatorObserver {
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
  initialLocation: initialLocation,
  observers: [
    GoRouterObserver(),
  ],
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
          builder: (context, state) => const ReceiveGoodsScanPage(),
        ),
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final good = extras['good'] as GoodEntity;
            final batchName = extras['batchName'] as String;
            final receiveAt = extras['receiveAt'] as DateTime?;

            return ReceiveGoodsDetailPage(
              batchName: batchName,
              good: good,
              receiveAt: receiveAt,
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
          builder: (context, state) => PrepareGoodsScanPage(
            batchName: '${state.extra}',
          ),
        ),
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final extras = state.extra as Map<String, dynamic>;
            final good = extras['good'] as GoodEntity;
            final batchName = extras['batchName'] as String;
            final nextWarehouse = extras['nextWarehouse'] as WarehouseEntity;
            final estimateAt = extras['estimateAt'] as DateTime;
            final shipmentAt = extras['shipmentAt'] as DateTime;

            return PrepareGoodsDetailPage(
              batchName: batchName,
              good: good,
              nextWarehouse: nextWarehouse,
              estimateAt: estimateAt,
              shipmentAt: shipmentAt,
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
          builder: (context, state) => const SendGoodsScanPage(),
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
          builder: (context, state) => const PickUpGoodsConfirmationPage(),
        ),
        GoRoute(
          path: 'scan',
          builder: (context, state) => const PickUpGoodsScanPage(),
        ),
      ],
    ),

    // On The Way Detail
    GoRoute(
      path: '/on-the-way-detail',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final good = extras['good'] as GoodEntity;
        final batchName = extras['batchName'] as String;
        final shipmentAt = extras['shipmentAt'] as DateTime;

        return OnTheWayDetailPage(
          batchName: batchName,
          good: good,
          shipmentAt: shipmentAt,
        );
      },
    ),

    // Inventory Detail
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
      path: '/item-detail',
      builder: (context, state) => const ItemDetailPage(itemId: ''),
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
