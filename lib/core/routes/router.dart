import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../features/inventory/domain/entities/lost_good_entity.dart';
import '../../features/inventory/domain/entities/picked_good_entity.dart';
import '../../features/inventory/presentation/cubit/receipt_number_cubit.dart';
import '../../features/inventory/presentation/cubit/scanner_cubit.dart';
import '../../features/inventory/presentation/pages/inventory/inventory_detail_page.dart';
import '../../features/inventory/presentation/pages/inventory/inventory_page.dart';
import '../../features/inventory/presentation/pages/lost_good_page.dart';
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
import '../../features/inventory/presentation/pages/receipt_number_page.dart';
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

const onboardingRoute = 'onboarding';
const loginRoute = 'login';

const menuRoute = 'menu';
const receiveGoodsRoute = 'receive-goods';
const receiveGoodsFilterRoute = '$receiveGoodsRoute.filter';
const receiveGoodsScanRoute = '$receiveGoodsRoute.scan';
const receiveGoodsDetailRoute = '$receiveGoodsRoute.detail';
const prepareGoodsRoute = 'prepare-goods';
const prepareGoodsFilterRoute = '$prepareGoodsRoute.filter';
const prepareGoodsScanRoute = '$prepareGoodsRoute.scan';
const prepareGoodsDetailRoute = '$prepareGoodsRoute.detail';
const sendGoodsRoute = 'send-goods';
const sendGoodsFilterRoute = '$sendGoodsRoute.filter';
const sendGoodsScanRoute = '$sendGoodsRoute.scan';
const sendGoodsDetailRoute = '$sendGoodsRoute.detail';
const pickUpGoodsRoute = 'pick-up-goods';
const pickUpGoodsConfirmationRoute = '$pickUpGoodsRoute.confirmation';
const pickUpGoodsScanRoute = '$pickUpGoodsRoute.scan';
const pickUpGoodsDetailRoute = '$pickUpGoodsRoute.detail';
const receiptNumbersRoute = 'receipt-numbers';

const onTheWayRoute = 'on-the-way';
const onTheWayDetailRoute = 'on-the-way.detail';

const scanBarcodeInnerRoute = 'scan-barcode-inner';
const lostGoodRoute = 'lost-good';

const inventoryRoute = 'inventory';
const inventoryDetailRoute = 'inventory.detail';

const settingRoute = 'setting';
const notificationRoute = 'notification';

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
          name: menuRoute,
          builder: (context, state) => const HomePage(),
          routes: [
            // Receive Goods
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: 'receive-goods',
              name: receiveGoodsRoute,
              builder: (context, state) => const ReceiveGoodsPage(),
              routes: <RouteBase>[
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'filter',
                  name: receiveGoodsFilterRoute,
                  builder: (context, state) => const ReceiveGoodsFilterPage(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'scan',
                  name: receiveGoodsScanRoute,
                  builder: (context, state) {
                    final extras = state.extra as Map<String, dynamic>;
                    final origin = extras['origin'] as DropdownEntity;
                    final receivedAt = extras['receivedAt'] as DateTime;

                    return BlocProvider(
                      create: (context) => ScannerCubit(),
                      child: ReceiveGoodsScanPage(
                        origin: origin,
                        receivedAt: receivedAt,
                      ),
                    );
                  },
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'detail',
                  name: receiveGoodsDetailRoute,
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
              parentNavigatorKey: _rootNavigatorKey,
              path: 'prepare-goods',
              name: prepareGoodsRoute,
              builder: (context, state) => const PrepareGoodsPage(),
              routes: <RouteBase>[
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'filter',
                  name: prepareGoodsFilterRoute,
                  builder: (context, state) => const PrepareGoodsFilterPage(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'scan',
                  name: prepareGoodsScanRoute,
                  builder: (context, state) {
                    final extras = state.extra as Map<String, dynamic>;
                    final shippedAt = extras['shippedAt'] as DateTime;
                    final estimatedAt = extras['estimatedAt'] as DateTime;
                    final nextWarehouse =
                        extras['nextWarehouse'] as DropdownEntity;
                    final transportMode =
                        extras['transportMode'] as DropdownEntity;
                    final batchName = extras['batchName'] as String;

                    return BlocProvider(
                      create: (context) => ScannerCubit(),
                      child: PrepareGoodsScanPage(
                        shippedAt: shippedAt,
                        estimatedAt: estimatedAt,
                        nextWarehouse: nextWarehouse,
                        transportMode: transportMode,
                        batchName: batchName,
                      ),
                    );
                  },
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'detail',
                  name: prepareGoodsDetailRoute,
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
              parentNavigatorKey: _rootNavigatorKey,
              path: 'send-goods',
              name: sendGoodsRoute,
              builder: (context, state) => const SendGoodsPage(),
              routes: <RouteBase>[
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'filter',
                  name: sendGoodsFilterRoute,
                  builder: (context, state) => const SendGoodsFilterPage(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'scan',
                  name: sendGoodsScanRoute,
                  builder: (context, state) {
                    final extras = state.extra as Map<String, dynamic>;
                    final driver = extras['driver'] as DropdownEntity;
                    final nextWarehouse =
                        extras['nextWarehouse'] as DropdownEntity;
                    final deliveredAt = extras['deliveredAt'] as DateTime;

                    return BlocProvider(
                      create: (context) => ScannerCubit(),
                      child: SendGoodsScanPage(
                        driver: driver,
                        nextWarehouse: nextWarehouse,
                        deliveredAt: deliveredAt,
                      ),
                    );
                  },
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'detail',
                  name: sendGoodsDetailRoute,
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
              parentNavigatorKey: _rootNavigatorKey,
              path: 'pick-up-goods',
              name: pickUpGoodsRoute,
              builder: (context, state) => const PickUpGoodsPage(),
              routes: <RouteBase>[
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'scan',
                  name: pickUpGoodsScanRoute,
                  builder: (context, state) => const PickUpGoodsScanPage(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'confirmation',
                  name: pickUpGoodsConfirmationRoute,
                  builder: (context, state) => PickUpGoodsConfirmationPage(
                    selectedCodes: state.extra as Map<String, Set<String>>,
                  ),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'detail',
                  name: pickUpGoodsDetailRoute,
                  builder: (context, state) => PickUpGoodsDetailPage(
                    pickedGood: state.extra as PickedGoodEntity,
                  ),
                )
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/on-the-way',
          name: onTheWayRoute,
          builder: (context, state) => const OnTheWayPage(),
          routes: <RouteBase>[
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: 'detail',
              name: onTheWayDetailRoute,
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
          ],
        ),
        GoRoute(
          path: '/inventory',
          name: inventoryRoute,
          builder: (context, state) => const InventoryPage(),
          routes: <RouteBase>[
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: 'detail',
              name: inventoryDetailRoute,
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
          ],
        ),
        GoRoute(
          path: '/setting',
          name: settingRoute,
          builder: (context, state) => const SettingPage(),
        ),
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
      name: onboardingRoute,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/login',
      name: loginRoute,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/notification',
      name: notificationRoute,
      builder: (context, state) => const NotificationPage(),
    ),
    GoRoute(
      path: '/scan-barcode-inner',
      name: scanBarcodeInnerRoute,
      builder: (context, state) =>
          MobileScannerSimplePage(onDetect: context.pop),
    ),
    GoRoute(
      path: '/receipt-numbers',
      name: receiptNumbersRoute,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final batch = extras['batch'] as BatchEntity;
        final routeDetailName = extras['routeDetailName'] as String;

        return BlocProvider(
          create: (context) => ReceiptNumberCubit(batch: batch),
          child: ReceiptNumberPage(
            batch: batch,
            routeDetailName: routeDetailName,
          ),
        );
      },
    ),
    GoRoute(
      path: '/lost-good',
      name: lostGoodRoute,
      builder: (context, state) =>
          LostGoodPage(lostGood: state.extra as LostGoodEntity),
    ),
  ],
);
