import 'package:flutter/material.dart';
import 'package:hopehive/features/donate/donation_page.dart';
import 'package:hopehive/features/donate/presentation/create_donation_screen.dart';
import 'package:hopehive/features/home/presentation/pickup_dropoff_screen.dart';
import 'package:hopehive/features/home/presentation/urgency_needs_screen.dart';
import 'package:hopehive/features/onboarding/onboarding_page.dart';
import 'package:hopehive/features/auth/auth_page.dart';
import 'package:hopehive/features/auth/presentation/register_screen.dart';
import 'package:hopehive/features/auth/presentation/forgot_password_screen.dart';
import 'package:hopehive/features/home/home_page.dart';
import 'package:hopehive/features/profile/presentation/edit_profile_screen.dart';
import 'package:hopehive/features/request/presentation/create_request_screen.dart';
import 'package:hopehive/features/request/request_page.dart';
import 'package:hopehive/features/setting/setting_page.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot_password';
  static const String home = '/home';
  static const String setting = '/setting';
  static const String editProfile = '/edit_profile';
  static const String donation = '/donation';
  static const String request = '/request';
  static const String createDonation = '/create_donation';
  static const String createRequest = '/create_request';
  static const String urgencyNeeds = '/urgency_needs';
  static const String pickupDropoff = '/pickup_dropoff';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case login:
        return MaterialPageRoute(builder: (_) => AuthPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case setting:
        return MaterialPageRoute(builder: (_) => SettingPage());
      case editProfile:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());
      case donation:
        return MaterialPageRoute(builder: (_) => const DonationPage());
      case request:
        return MaterialPageRoute(builder: (_) => const RequestPage());
      case createDonation:
        return MaterialPageRoute(builder: (_) => CreateDonationScreen());
      case createRequest:
        return MaterialPageRoute(builder: (_) => CreateRequestScreen());
      case urgencyNeeds:
        return MaterialPageRoute(builder: (_) => const UrgencyNeedsScreen());
      case pickupDropoff:
        return MaterialPageRoute(builder: (_) => const PickupDropoffScreen());
      default:
        return MaterialPageRoute(builder: (_) => AuthPage());
    }
  }
}
