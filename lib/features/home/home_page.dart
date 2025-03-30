import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hopehive/features/chat/message_page.dart';
import 'package:hopehive/features/home/domain/home_page_provider.dart';
import 'package:hopehive/features/home/presentation/home_app_bar.dart';
import 'package:hopehive/features/home/presentation/home_screen.dart';
import 'package:hopehive/features/notification/notification_page.dart';
import 'package:hopehive/features/profile/presentation/profile_app_bar.dart';
import 'package:hopehive/features/profile/profile_page.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final List<Widget> _pages = [
    HomeScreen(),
    const MessagePage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  final List<PreferredSizeWidget?> _appBars = [
    const HomeAppBar(),
    null,
    null,
    const ProfileAppBar(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    return Scaffold(
      appBar: _appBars[currentIndex],
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            ref.read(currentIndexProvider.notifier).state = index;
          },
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          fixedColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.question_answer_rounded), label: 'Chat'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_rounded), label: 'Notification'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
