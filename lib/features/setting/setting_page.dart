import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final List<Map<String, dynamic>> _settings = [
    {
      'leading': Icons.security_outlined,
      'title': 'Password and Security',
      'subtitle': 'Change password and Manage your security settings',
      'onTap': (BuildContext context) {}
    },
    {
      'leading': Icons.verified_user_outlined,
      'title': 'Verification',
      'subtitle': 'Verification your email and phone number',
      'onTap': (BuildContext context) {}
    },
    {
      'leading': Icons.save_alt_outlined,
      'title': 'Saved',
      'subtitle': 'See your saved items',
      'onTap': (BuildContext context) {}
    },
    {
      'leading': Icons.location_on_outlined,
      'title': 'Location',
      'subtitle': 'Manage your location settings',
      'onTap': (BuildContext context) {}
    },
    {
      'leading': Icons.color_lens_outlined,
      'title': 'Appearance',
      'subtitle': 'Change the app theme',
      'onTap': (BuildContext context) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Appearance'),
              content: const Text('Change the app theme here.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    },
    {
      'leading': Icons.notifications_outlined,
      'title': 'Notifications',
      'subtitle': 'Manage your notifications settings',
      'onTap': (BuildContext context) {}
    },
    {
      'leading': Icons.language_outlined,
      'title': 'Language',
      'subtitle': 'Change the app language',
      'onTap': (BuildContext context) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Language'),
              content: const Text('Change the app language here.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    },
    {
      'leading': Icons.help_outline,
      'title': 'Help',
      'subtitle': 'Get help and support',
      'onTap': (BuildContext context) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Help'),
              content: const Text('Get help and support here.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    },
    {
      'leading': Icons.help_center_outlined,
      'title': 'About',
      'subtitle': 'About the app',
      'onTap': (BuildContext context) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('About HopeHive'),
              content: const Text('HopeHive is a mental health app.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    },
    {
      'leading': Icons.logout_rounded,
      'title': 'Logout',
      'subtitle': 'Exit from your account',
      'onTap': (BuildContext context) async {
        await FirebaseAuth.instance.signOut();
        if (!context.mounted) return;
        Navigator.pop(context);
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _settings.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: Icon(
                    _settings[index]['leading'],
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    _settings[index]['title'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  subtitle: Text(
                    _settings[index]['subtitle'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF696969),
                        ),
                  ),
                  trailing: _settings[index]['title'] == 'Logout'
                      ? null
                      : const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                          color: Color(0xFF696969),
                        ),
                  onTap: () => _settings[index]['onTap'](context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
