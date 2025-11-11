import 'package:flutter/material.dart';
import '../../models/quiz_question.dart';
import '../../core/constants/app_colors.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizResult result;

  const QuizResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Natijalar'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Trophy Icon
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getGradeColor().withAlpha(26),
                      ),
                      child: Icon(
                        _getGradeIcon(),
                        size: 80,
                        color: _getGradeColor(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Grade
                    Text(
                      result.grade,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: _getGradeColor(),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _getGradeText(),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: _getGradeColor(),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Stats Cards
                    _buildStatCard(
                      'To\'g\'ri javoblar',
                      '${result.correctAnswers}',
                      Icons.check_circle,
                      AppColors.success,
                      context,
                    ),

                    const SizedBox(height: 12),

                    _buildStatCard(
                      'Noto\'g\'ri javoblar',
                      '${result.wrongAnswers}',
                      Icons.cancel,
                      AppColors.error,
                      context,
                    ),

                    const SizedBox(height: 12),

                    _buildStatCard(
                      'Jami savollar',
                      '${result.totalQuestions}',
                      Icons.quiz,
                      AppColors.primary,
                      context,
                    ),

                    const SizedBox(height: 12),

                    _buildStatCard(
                      'Sarflangan vaqt',
                      _formatDuration(result.timeTaken),
                      Icons.timer,
                      AppColors.secondary,
                      context,
                    ),

                    const SizedBox(height: 12),

                    _buildStatCard(
                      'Ball',
                      '${result.scorePercentage.toStringAsFixed(0)}%',
                      Icons.star,
                      AppColors.warning,
                      context,
                    ),
                  ],
                ),
              ),
            ),

            // Action buttons
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  icon: const Icon(Icons.replay),
                  label: const Text('Qaytadan urinish'),
                ),

                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  icon: const Icon(Icons.home),
                  label: const Text('Bosh sahifa'),
                ),
              ],
            ),
          ],
        ),
      ),
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

  Color _getGradeColor() {
    switch (result.grade) {
      case 'A':
        return AppColors.success;
      case 'B':
        return AppColors.info;
      case 'C':
        return AppColors.warning;
      case 'D':
        return AppColors.error;
      default:
        return Colors.red.shade800;
    }
  }

  IconData _getGradeIcon() {
    switch (result.grade) {
      case 'A':
        return Icons.emoji_events;
      case 'B':
        return Icons.thumb_up;
      case 'C':
        return Icons.sentiment_neutral;
      case 'D':
        return Icons.sentiment_dissatisfied;
      default:
        return Icons.sentiment_very_dissatisfied;
    }
  }

  String _getGradeText() {
    switch (result.grade) {
      case 'A':
        return 'A\'lo!';
      case 'B':
        return 'Yaxshi!';
      case 'C':
        return 'Qoniqarli';
      case 'D':
        return 'Qoniqarsiz';
      default:
        return 'Yomon';
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }
}