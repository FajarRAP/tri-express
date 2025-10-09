import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/top_snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../cubit/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthCubit _authCubit;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final GlobalKey<FormState> _formKey;
  var _isObscure = true;

  @override
  void initState() {
    super.initState();
    _authCubit = context.read<AuthCubit>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                bottom: 0,
                child: Image.asset(
                  loginImagePath,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 24,
                left: 16,
                child: Image.asset(
                  logoTextImagePath,
                  width: 128,
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.viewInsetsOf(context).bottom,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(color: light),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 40,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Let\'s Login with Your Account',
                            style: heading5[bold],
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'Masukkan email anda',
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: nullValidator,
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            onFieldSubmitted: (_) => _authCubit.login(
                                email: _emailController.text,
                                password: _passwordController.text),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: 'Masukkan password anda',
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _isObscure = !_isObscure),
                                icon: Icon(_isObscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                              ),
                            ),
                            obscureText: _isObscure,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.send,
                            validator: nullValidator,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: BlocConsumer<AuthCubit, AuthState>(
                              buildWhen: (previous, current) =>
                                  current is Login,
                              listenWhen: (previous, current) =>
                                  current is Login,
                              listener: (context, state) {
                                if (state is LoginLoaded) {
                                  TopSnackbar.successSnackbar(
                                      message: 'success login');
                                  context.goNamed(menuRoute);
                                }
                                if (state is LoginError) {
                                  TopSnackbar.dangerSnackbar(
                                      message: state.message);
                                }
                              },
                              builder: (context, state) {
                                if (state is LoginLoading) {
                                  return const PrimaryButton(
                                    child: Text('Masuk'),
                                  );
                                }

                                return PrimaryButton(
                                  onPressed: () {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    _authCubit.login(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                  },
                                  child: const Text('Masuk'),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            '2025 © PT. Tri Perkasa Express. All Right Reserved',
                            style: TextStyle(
                              fontSize: 12,
                              color: grayTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
