import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
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
      child: Scaffold(
        backgroundColor: light,
        body: Center(child: Image.asset(logoImagePath, width: 80)),
      ),
    );
  }
}
