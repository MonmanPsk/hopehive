import 'package:hopehive/features/onboarding/data/onboarding_item.dart';

class OnboardingData {
  List<OnboardingItem> data = [
    OnboardingItem(
      title: 'Welcome to HopeHive',
      description: "Join a Community of Givers & Receivers\nEasily donate or request essential items and help make a difference in someone's life.",
      image: 'assets/images/onboarding1.gif',
    ),
    OnboardingItem(
      title: 'Donate with Ease',
      description: 'Give What You Can, When You Can\nShare clothes, books, food, and more with those in need—quick, simple, and impactful.',
      image: 'assets/images/onboarding2.gif',
    ),
    OnboardingItem(
      title: 'Request Support',
      description: 'Get the Help You Need, Hassle-Free\nRequest essential items and connect with generous donors in your community.',
      image: 'assets/images/onboarding3.gif',
    ),
    OnboardingItem(
      title: 'Safe & Reliable',
      description: 'Secure and Trusted Donations\nEvery donation is tracked, and you can choose who to donate to or let the app match you with those in need.',
      image: 'assets/images/onboarding4.gif',
    ),
  ];
}
