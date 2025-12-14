import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/event_log_module/screen.dart';
import 'package:library_kursach/modules_admin/users_users_module/screen.dart';
import 'package:library_kursach/modules_admin/settings_module/screen.dart';
import 'package:library_kursach/modules_admin/statistic_module/screen.dart';

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({super.key});

  static const List<_AdminTab> _tabs = [
    _AdminTab(path: StatisticScreen.path, label: 'Статистика', icon: Icons.analytics_outlined),
    _AdminTab(path: ManageUsersScreen.path, label: 'Користувачі', icon: Icons.people_outline),
    _AdminTab(path: EventLogScreen.path, label: 'Журнал подій', icon: Icons.history),
    _AdminTab(path: SettingsScreen.path, label: 'Налаштування', icon: Icons.settings_outlined),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _tabs.indexWhere((tab) => location == tab.path);
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _currentIndex(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: _tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Material(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () => context.go(tab.path),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      Icon(tab.icon, size: 20, color: isSelected ? Colors.white : AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        tab.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AdminTab {
  const _AdminTab({required this.path, required this.label, required this.icon});
  final String path;
  final String label;
  final IconData icon;
}
