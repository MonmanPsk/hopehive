import 'package:flutter/material.dart';
import 'package:hopehive/features/onboarding/presentation/onboarding_screen.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: OnboardingScreen(),
    );
  }
}
