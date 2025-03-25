import 'package:flutter/material.dart';
import 'package:hopehive/features/onboarding/onboarding_page.dart';
import 'package:hopehive/features/auth/auth_page.dart';
import 'package:hopehive/features/auth/presentation/register_screen.dart';
import 'package:hopehive/features/auth/presentation/forgot_password_screen.dart';
import 'package:hopehive/features/home/home_page.dart';
import 'package:hopehive/features/profile/presentation/setting_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/';
  static const String register = '/register';
  static const String forgotPassword = '/forgot_password';
  static const String home = '/home';
  static const String setting = '/setting';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case login:
        return MaterialPageRoute(builder: (_) => AuthPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case setting:
        return MaterialPageRoute(builder: (_) => const SettingScreen());
      default:
        return MaterialPageRoute(builder: (_) => const Center());
    }
  }
}
