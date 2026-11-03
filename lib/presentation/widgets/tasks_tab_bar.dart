import 'package:flutter/material.dart';

class TasksTabBar extends StatelessWidget implements PreferredSizeWidget {
  const TasksTabBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      tabs: [
        Tab(text: 'Pendientes'),
        Tab(text: 'Completadas'),
      ],
    );
  }
}
