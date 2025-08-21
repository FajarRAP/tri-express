import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import 'core/routes/router.dart';
import 'core/themes/theme.dart';
import 'core/utils/helpers.dart';

late Faker faker;

void main() {
  faker = Faker();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
    );
  }
}
