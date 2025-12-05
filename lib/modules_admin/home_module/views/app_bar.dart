import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/modules_admin/home_module/screen.dart';
import 'package:library_kursach/modules_admin/event_log_module/screen.dart';
import 'package:library_kursach/modules_admin/users_users_module/screen.dart';
import 'package:library_kursach/modules_admin/settings_module/screen.dart';
import 'package:library_kursach/modules_admin/statistic_module/screen.dart';

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({super.key});

  static const List<_AdminTab> _tabs = [
    _AdminTab(
      path: StatisticScreen.path,
      label: 'Statistic',
      icon: Icons.analytics,
    ),
    _AdminTab(
      path: ManageUsersScreen.path,
      label: 'Manage Users',
      icon: Icons.people,
    ),
    _AdminTab(path: EventLogScreen.path, label: 'Event Log', icon: Icons.event),
    _AdminTab(
      path: SettingsScreen.path,
      label: 'Settings',
      icon: Icons.settings,
    ),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _tabs.indexWhere((tab) => location == tab.path);
    return index == -1 ? 0 : index;
  }

  void _onItemTap(BuildContext context, int index) {
    final targetPath = _tabs[index].path;
    final currentLocation = GoRouterState.of(context).matchedLocation;
    if (currentLocation != targetPath) {
      context.go(targetPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _currentIndex(context);
    final selectedTab = _tabs[selectedIndex];

    return AppBar(
      backgroundColor: Colors.grey[200],
      title: Text(selectedTab.label),
      actions: [
        ..._tabs.map(
          (tab) => Padding(
            padding: const EdgeInsets.only(right: 100),
            child: IconButton(
              onPressed:
                  () =>
                      tab.path == AdminScreen.path
                          ? context.go(AdminScreen.path)
                          : _onItemTap(context, _tabs.indexOf(tab)),
              color:
                  selectedIndex == _tabs.indexOf(tab)
                      ? Colors.blue
                      : Colors.grey,
              icon: Icon(tab.icon),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdminTab {
  const _AdminTab({
    required this.path,
    required this.label,
    required this.icon,
  });

  final String path;
  final String label;
  final IconData icon;
}
