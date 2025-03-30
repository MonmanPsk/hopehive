import 'package:flutter/material.dart';

class NotificationTab extends StatelessWidget {
  const NotificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.notifications_active_outlined,
          color: Colors.white,
        ),
      ),
      title: Text(
        'Thank you for your donation! Your contribution is confirmed.',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        '2h ago',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
