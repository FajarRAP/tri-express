import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routes/router.dart';
import 'core/themes/theme.dart';
import 'core/utils/helpers.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'service_locator.dart';

late Faker faker;

void main() {
  setupServiceLocator();
  faker = Faker();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => getIt.get<AuthCubit>()),
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
