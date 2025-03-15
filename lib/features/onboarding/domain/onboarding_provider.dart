import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/features/onboarding/data/onboarding_data.dart';

class OnboardingState extends StateNotifier<int> {
  OnboardingState() : super(0);

  final PageController pageController = PageController();
  final onboardingData = OnboardingData();

  void nextPage() {
    if (state < onboardingData.data.length - 1) {
      state++;
      pageController.animateToPage(
        state,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (state > 0) {
      state--;
      pageController.animateToPage(
        state,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    state = onboardingData.data.length - 1;
    pageController.jumpToPage(state);
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingState, int>((ref) {
  return OnboardingState();
});
