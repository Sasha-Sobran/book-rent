import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/reader.dart';
import 'package:library_kursach/modules/rents_module/screen.dart';

class ReaderCard extends StatelessWidget {
  final Reader reader;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool canNavigateToRents;

  const ReaderCard({
    super.key,
    required this.reader,
    this.onEdit,
    this.onDelete,
    this.canNavigateToRents = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: canNavigateToRents ? () => context.go('${RentsScreen.path}?reader_id=${reader.id}') : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: AppDecorations.cardDecoration,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: reader.isLinkedToUser ? AppColors.primary : AppColors.secondary,
                radius: 20,
                child: Text(
                  '${reader.name[0]}${reader.surname[0]}'.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reader.fullName, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                    if (reader.readerCategoryName != null)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(reader.readerCategoryName!, style: AppTextStyles.caption.copyWith(color: AppColors.warning)),
                      ),
                  ],
                ),
              ),
              if (onEdit != null)
              IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, color: AppColors.secondary)),
              if (onDelete != null)
              IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: AppColors.error)),
            ],
          ),
          const SizedBox(height: 6),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 6),
          Row(
            children: [
              if (reader.phoneNumber != null) ...[
                Icon(Icons.phone_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(reader.phoneNumber!, style: AppTextStyles.caption),
                const SizedBox(width: 16),
              ],
              if (reader.userEmail != null) ...[
                Icon(Icons.email_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(reader.userEmail!, style: AppTextStyles.caption),
                const SizedBox(width: 16),
              ],
              if (reader.address != null) ...[
                Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Flexible(child: Text(reader.address!, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis)),
              ],
            ],
          ),
          if (reader.isLinkedToUser)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Icon(Icons.link, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text('Прив\'язаний до акаунту', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                ],
              ),
            ),
        ],
      ),
      ),
    );
  }
}

