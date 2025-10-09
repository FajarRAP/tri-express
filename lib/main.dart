import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'core/routes/router.dart';
import 'core/themes/theme.dart';
import 'core/utils/top_snackbar.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/core/presentation/cubit/core_cubit.dart';
import 'features/inventory/presentation/cubit/inventory_cubit.dart';
import 'firebase_options.dart';
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupServiceLocator();

  timeago.setLocaleMessages('id', timeago.IdMessages());
  Intl.defaultLocale = 'id_ID';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CoreCubit>(create: (context) => getIt<CoreCubit>()),
        BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
        BlocProvider<InventoryCubit>(
            create: (context) => getIt<InventoryCubit>()),
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
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('en'), // English
          Locale('id'), // Indonesian
        ],
        routerConfig: router,
        theme: theme,
        title: 'Tri Express',
      ),
    );
  }
}
