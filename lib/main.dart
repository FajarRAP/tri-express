import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/routes/router.dart';
import 'core/themes/theme.dart';
import 'core/utils/constants.dart';
import 'core/utils/helpers.dart';
import 'features/auth/data/data_sources/auth_local_data_sources.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/core/presentation/cubit/core_cubit.dart';
import 'features/inventory/presentation/cubit/inventory_cubit.dart';
import 'service_locator.dart';

late Faker faker;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  faker = Faker();
  final storage = getIt.get<FlutterSecureStorage>();
  final authLocal = getIt.get<AuthLocalDataSources>();
  initialLocation = await storage.read(key: onboardingKey) == null
      ? onboardingRoute
      : await authLocal.getAccessToken() != null
          ? menuRoute
          : loginRoute;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CoreCubit>(create: (context) => getIt.get<CoreCubit>()),
        BlocProvider<AuthCubit>(create: (context) => getIt.get<AuthCubit>()),
        BlocProvider<InventoryCubit>(
            create: (context) => getIt.get<InventoryCubit>()),
      ],
      child: MaterialApp.router(
        builder: (context, child) => Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(builder: (context) {
              TopSnackbar.init(context);
              return child!;
            }),
          ],
        ),
        routerConfig: router,
        theme: theme,
        title: 'Tri Express',
      ),
    );
  }
}
