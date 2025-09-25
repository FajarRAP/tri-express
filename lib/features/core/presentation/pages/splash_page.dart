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
      listener: (context, state) {
        if (state is FirstTimeUser) {
          return context.go(onboardingRoute);
        }

        if (state is Unauthenticated) {
          return context.go(loginRoute);
        }

        if (state is Authenticated) {
          return context.go(menuRoute);
        }
      },
      child: const Scaffold(body: Center(child: FlutterLogo(size: 100))),
    );
  }
}
