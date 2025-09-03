import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/fonts/fonts.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/buttons/primary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  var _isObscure = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              bottom: 0,
              child: Image.asset(
                onboardingImagePath,
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
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: light,
                    ),
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
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Masukkan email anda',
                            labelText: 'Email',
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
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
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                            onPressed: () => context.go(menuRoute),
                            child: const Text('Mulai Sekarang'),
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
      resizeToAvoidBottomInset: false,
    );
  }
}
