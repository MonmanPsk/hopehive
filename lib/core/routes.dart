import 'package:flutter/material.dart';
import 'package:hopehive/features/auth/presentation/forgot_password_screen.dart';
import 'package:hopehive/features/auth/presentation/login_screen.dart';
import 'package:hopehive/features/auth/presentation/register_screen.dart';
import 'package:hopehive/features/home/home_page.dart';
import 'package:hopehive/features/onboarding/onboarding_page.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot_password';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(builder: (_) => const Center());
    }
  }
}
