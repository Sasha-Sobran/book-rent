import 'package:flutter/material.dart';
import 'package:library_kursach/models/user.dart';

class RoleItem extends StatelessWidget {
  final Role role;

  const RoleItem({super.key, required this.role});

  Color _getRoleColor() {
    switch (role.name.toLowerCase()) {
      case 'admin':
        return Colors.purple;
      case 'root':
        return Colors.orange;
      case 'librarian':
        return Colors.green;
      case 'reader':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon() {
    switch (role.name.toLowerCase()) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'root':
        return Icons.security;
      case 'librarian':
        return Icons.library_books;
      case 'reader':
        return Icons.person;
      default:
        return Icons.badge;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor();
    final roleIcon = _getRoleIcon();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Icon(
              roleIcon,
              color: roleColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                role.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}