import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/reader.dart';

class ReaderCard extends StatelessWidget {
  final Reader reader;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ReaderCard({super.key, required this.reader, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: reader.isLinkedToUser ? AppColors.primary : AppColors.secondary,
                radius: 24,
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
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(reader.readerCategoryName!, style: AppTextStyles.caption.copyWith(color: AppColors.warning)),
                      ),
                  ],
                ),
              ),
              IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, color: AppColors.secondary)),
              IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: AppColors.error)),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
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
              padding: const EdgeInsets.only(top: 8),
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
    );
  }
}

