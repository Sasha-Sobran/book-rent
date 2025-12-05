import 'package:flutter/material.dart';
import 'package:library_kursach/models/user.dart';

class UserItem extends StatelessWidget {
  final User user;

  const UserItem({super.key, required this.user});

  IconData _getIconForRole(String role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings_outlined;
      case 'librarian':
        return Icons.library_books_outlined;
      case 'reader':
        return Icons.person_outline;
      case 'root':
        return Icons.security;
      default:
        return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 50,
              children: [
                Icon(_getIconForRole(user.role)),
                Text(user.name),
                Text(user.surname),
                Text(user.email),
                Text(user.role),
                Text(user.phoneNumber ?? ''),
              ],
            ),
            Row(
              children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
              ],
            )
          ],
        ),
      ),
    );
  }
}