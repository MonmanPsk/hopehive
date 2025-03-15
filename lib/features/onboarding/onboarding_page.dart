import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/features/onboarding/domain/onboarding_provider.dart';
import 'package:hopehive/features/onboarding/presentation/onboarding_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        // leadingWidth: 100,
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 20),
        //   child: Row(
        //     children: [
        //       RichText(
        //         text: const TextSpan(
        //           children: [
        //             TextSpan(
        //               text: 'TH',
        //               style: TextStyle(fontWeight: FontWeight.bold),
        //             ),
        //             TextSpan(
        //               text: ' | ',
        //               style: TextStyle(fontWeight: FontWeight.bold),
        //             ),
        //             TextSpan(
        //               text: 'EN',
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        actions: [
          if (onboardingState !=
              onboardingNotifier.onboardingData.data.length - 1)
            TextButton(
              onPressed: onboardingNotifier.skip,
              child: const Text(
                'SKIP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: const OnboardingScreen(),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: onboardingState ==
                onboardingNotifier.onboardingData.data.length - 1
            ? SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: onboardingState > 0,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: ElevatedButton(
                      onPressed: onboardingNotifier.previousPage,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: onboardingNotifier.pageController,
                    count: onboardingNotifier.onboardingData.data.length,
                    effect: ExpandingDotsEffect(
                      dotWidth: 8,
                      dotHeight: 8,
                      activeDotColor: Colors.white,
                      dotColor: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onboardingNotifier.nextPage,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                    child:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                  ),
                ],
              ),
      ),
    );
  }
}
