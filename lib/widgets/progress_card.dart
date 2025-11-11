import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class ProgressCard extends StatelessWidget {
  final int learnedWords;
  final int totalWords;
  final int favoriteWords;
  final double progress;

  const ProgressCard({
    super.key,
    required this.learnedWords,
    required this.totalWords,
    required this.favoriteWords,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assalomu alaykum! 👋',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bugun qaysi so\'zlarni o\'rganamiz?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withAlpha(230),
            ),
          ),
          const SizedBox(height: 20),

          // Stats Row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  '$learnedWords',
                  'O\'rganilgan',
                  Icons.check_circle_outline,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withAlpha(77),
                ),
                _buildStatItem(
                  '$totalWords',
                  'Jami so\'zlar',
                  Icons.library_books,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withAlpha(77),
                ),
                _buildStatItem(
                  '$favoriteWords',
                  'Sevimli',
                  Icons.favorite,
                ),
              ],
            ),
          ),

          // Progress bar
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'O\'rganish jarayoni',
                    style: TextStyle(
                      color: Colors.white.withAlpha(230),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${progress.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress / 100,
                  minHeight: 8,
                  backgroundColor: Colors.white.withAlpha(77),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(230),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// Detailed Statistics Card (Profile page uchun)
class DetailedStatsCard extends StatelessWidget {
  final Map<String, int> stats;

  const DetailedStatsCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatCard(
          'O\'rganilgan so\'zlar',
          '${stats['learned'] ?? 0}',
          Icons.check_circle,
          AppColors.success,
          context,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          'Sevimli so\'zlar',
          '${stats['favorites'] ?? 0}',
          Icons.favorite,
          Colors.red,
          context,
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          'Jami so\'zlar',
          '${stats['total'] ?? 0}',
          Icons.library_books,
          AppColors.primary,
          context,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      BuildContext context,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withAlpha(77),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Category Progress Widget
class CategoryProgressWidget extends StatelessWidget {
  final String categoryName;
  final int learnedWords;
  final int totalWords;
  final Color color;

  const CategoryProgressWidget({
    super.key,
    required this.categoryName,
    required this.learnedWords,
    required this.totalWords,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalWords > 0 ? (learnedWords / totalWords) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                '$learnedWords / $totalWords',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: color.withAlpha(51),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}