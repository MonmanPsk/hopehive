import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/features/onboarding/domain/onboarding_provider.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingData = ref.read(onboardingProvider.notifier).onboardingData;
    final pageController = ref.read(onboardingProvider.notifier).pageController;

    return Stack(
      children: [
        Positioned(
          top: 60,
          right: -100,
          child: Container(
            height: 400,
            width: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF46CDCF),
            ),
          ),
        ),
        Positioned(
          left: -110,
          bottom: -60,
          child: Container(
            height: 500,
            width: 500,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF46CDCF),
            ),
          ),
        ),
        PageView.builder(
          itemCount: onboardingData.data.length,
          controller: pageController,
          onPageChanged: (index) =>
              ref.read(onboardingProvider.notifier).state = index,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 400,
                    child: Image.asset(onboardingData.data[index].image),
                  ),
                  Text(
                    onboardingData.data[index].title,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    onboardingData.data[index].description,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
