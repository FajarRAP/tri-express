import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/router.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return BlocListener<AuthCubit, AuthState>(
      bloc: authCubit..checkAuthentication(),
      listener: (context, state) => switch (state) {
        FirstTimeUser() => context.goNamed(onboardingRoute),
        Unauthenticated() => context.goNamed(loginRoute),
        Authenticated() => context.goNamed(menuRoute),
        _ => null,
      },
      child: const Scaffold(body: Center(child: FlutterLogo(size: 100))),
    );
  }
}
