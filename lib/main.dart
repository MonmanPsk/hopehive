import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/core/providers/theme_provider.dart';
import 'package:hopehive/core/routes.dart';
import 'package:hopehive/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hopehive/features/auth/auth_page.dart';
import 'package:hopehive/features/home/home_page.dart';
import 'package:hopehive/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'HopeHive',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.hasData ? HomePage() : AuthPage();
        },
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? AppRoutes.onboarding
          : null,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
