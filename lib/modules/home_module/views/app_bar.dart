import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/common_cubit/app_cubit/state.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/books_module/screen.dart';
import 'package:library_kursach/modules/main_module/screen.dart';
import 'package:library_kursach/modules/profile_module/screen.dart';
import 'package:library_kursach/modules/readers_module/screen.dart';
import 'package:library_kursach/modules/rents_module/screen.dart';
import 'package:library_kursach/modules/my_rents_module/screen.dart';
import 'package:library_kursach/utils/permission_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  List<_HomeTab> _tabsForUser(AppState state) {
    final user = state.user;
    final canSeeReaders = PermissionUtils.canSeeReaders(user);
    final isLibrarian = user?.isLibrarian == true;
    final isRegular = user != null && !isLibrarian && user.isAdmin != true && user.isRoot != true;
    final isAdminOrRoot = PermissionUtils.isAdminOrRoot(user);

    final tabs = <_HomeTab>[];
    
    if (!isAdminOrRoot) {
      tabs.add(_HomeTab(path: MainScreen.path, label: 'Головна', icon: Icons.home_outlined));
    }
    
    tabs.add(_HomeTab(path: BooksScreen.path, label: 'Книги', icon: Icons.menu_book_outlined));
    if (isLibrarian) {
      tabs.add(_HomeTab(path: RentsScreen.path, label: 'Ренти', icon: Icons.assignment_outlined));
    } else if (isRegular) {
      tabs.add(_HomeTab(path: MyRentsScreen.path, label: 'Мої ренти', icon: Icons.assignment_ind_outlined));
    }
    tabs.add(_HomeTab(path: ProfileScreen.path, label: 'Профіль', icon: Icons.person_pin_circle_outlined));
    if (canSeeReaders) {
      tabs.add(_HomeTab(path: ReadersModuleScreen.path, label: 'Читачі', icon: Icons.person_outline));
    }
    return tabs;
  }

  int _currentIndex(BuildContext context, List<_HomeTab> tabs) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = tabs.indexWhere((tab) => location == tab.path);
    return index == -1 ? 0 : index;
  }

  void _onItemTap(BuildContext context, List<_HomeTab> tabs, int index) {
    final targetPath = tabs[index].path;
    final currentLocation = GoRouterState.of(context).matchedLocation;
    if (currentLocation != targetPath) {
      context.go(targetPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      bloc: GetItService().instance<AppCubit>(),
      builder: (context, state) {
        final tabs = _tabsForUser(state);
        final selectedIndex = _currentIndex(context, tabs);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isSelected = selectedIndex == index;

              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Material(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => _onItemTap(context, tabs, index),
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
      },
    );
  }
}

class _HomeTab {
  const _HomeTab({required this.path, required this.label, required this.icon});

  final String path;
  final String label;
  final IconData icon;
}
