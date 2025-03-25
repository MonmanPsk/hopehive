import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hopehive/core/routes.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Sign out the user
            FirebaseAuth.instance.signOut();
            // Clear the navigation stack and navigate to login
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) =>
                  false, // This will remove all the routes from the stack
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
