import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/modules/books_module/screen.dart';
import 'package:library_kursach/modules/main_module/screen.dart';
import 'package:library_kursach/modules/users_module/screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  static const List<_HomeTab> _tabs = [
    _HomeTab(
      path: MainScreen.path,
      label: 'Головна',
      icon: Icons.home_outlined,
    ),
    _HomeTab(
      path: BooksScreen.path,
      label: 'Книги',
      icon: Icons.menu_book_outlined,
    ),
    _HomeTab(
      path: UsersScreen.path,
      label: 'Користувачі',
      icon: Icons.person_outline,
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
              onPressed: () => _onItemTap(context, _tabs.indexOf(tab)),
              color: selectedIndex == _tabs.indexOf(tab) ? Colors.blue : Colors.grey,
              icon: Icon(tab.icon),
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeTab {
  const _HomeTab({required this.path, required this.label, required this.icon});

  final String path;
  final String label;
  final IconData icon;
}
