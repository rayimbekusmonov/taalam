import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/arabic_text.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final int wordsCount;
  final Color color;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.wordsCount,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withAlpha(77),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji
              Text(
                category.icon,
                style: const TextStyle(fontSize: 42),
              ),

              const SizedBox(height: 8),

              // O'zbek nomi
              Text(
                category.nameUz,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.withAlpha(204),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 6),

              // Arab nomi
              ArabicTextSmall(
                category.nameAr,
                color: AppColors.textSecondary,
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$wordsCount so\'z',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}