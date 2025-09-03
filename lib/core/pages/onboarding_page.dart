import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../fonts/fonts.dart';
import '../routes/router.dart';
import '../themes/colors.dart';
import '../utils/constants.dart';
import '../widgets/buttons/primary_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

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
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                        'Make your warehouse workflow faster, simpler, and more organized',
                        style: heading5[bold],
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'From goods arrival to courier handoff, our RFID system guides you step by step.',
                        style: paragraphSmall[regular].copyWith(
                          color: grayTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          onPressed: () => context.go(loginRoute),
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
          ],
        ),
      ),
    );
  }
}
