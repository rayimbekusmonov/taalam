import 'package:flutter/material.dart';
import '../../models/word_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/arabic_text.dart';

class WordCard extends StatelessWidget {
  final Word word;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onLearned;

  const WordCard({
    super.key,
    required this.word,
    required this.onTap,
    required this.onFavorite,
    required this.onLearned,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Emoji/Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    word.emoji ?? '📝',
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // So'z ma'lumotlari
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Arabic text (RTL)
                    ArabicTextMedium(
                      word.arabic,
                      textAlign: TextAlign.right,
                    ),

                    const SizedBox(height: 6),

                    // Transliteration
                    Text(
                      word.transliteration,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // O'zbek tarjimasi
                    Text(
                      word.uzbek,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Favorite button
                  IconButton(
                    icon: Icon(
                      word.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: word.isFavorite ? Colors.red : Colors.grey,
                      size: 22,
                    ),
                    onPressed: onFavorite,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),

                  // Learned button
                  IconButton(
                    icon: Icon(
                      word.isLearned ? Icons.check_circle : Icons.circle_outlined,
                      color: word.isLearned ? AppColors.success : Colors.grey,
                      size: 22,
                    ),
                    onPressed: onLearned,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}