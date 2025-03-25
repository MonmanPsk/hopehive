import 'package:flutter/material.dart';
import 'package:hopehive/features/chat/message_page.dart';
import 'package:hopehive/features/home/presentation/home_app_bar.dart';
import 'package:hopehive/features/home/presentation/home_screen.dart';
import 'package:hopehive/features/notification/notification_page.dart';
import 'package:hopehive/features/profile/presentation/profile_app_bar.dart';
import 'package:hopehive/features/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
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

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_currentIndex],
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded), label: 'Notification'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
