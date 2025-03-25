import 'package:flutter/material.dart';
import 'package:hopehive/core/routes.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.setting),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
