import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/word_model.dart';
import '../../providers/word_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/arabic_text.dart';
import '../../widgets/audio_player_widget.dart';

class WordDetailScreen extends StatelessWidget {
  final Word word;

  const WordDetailScreen({
    super.key,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),

                      // Emoji
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            word.emoji ?? '📝',
                            style: const TextStyle(fontSize: 70),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Arabic text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ArabicTextLarge(
                          word.arabic,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Consumer<WordProvider>(
                builder: (context, wordProvider, child) {
                  return IconButton(
                    icon: Icon(
                      word.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: word.isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      wordProvider.toggleFavorite(word.id);
                    },
                  );
                },
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Transliteration
                  _buildInfoCard(
                    'Talaffuz',
                    word.transliteration,
                    Icons.record_voice_over,
                    AppColors.secondary,
                  ),

                  const SizedBox(height: 16),

                  // Uzbek meaning
                  _buildInfoCard(
                    'O\'zbekcha',
                    word.uzbek,
                    Icons.translate,
                    AppColors.primary,
                  ),

                  const SizedBox(height: 16),

                  // English meaning
                  _buildInfoCard(
                    'English',
                    word.english,
                    Icons.language,
                    AppColors.info,
                  ),

                  const SizedBox(height: 16),

                  // Difficulty
                  _buildDifficultyCard(),

                  const SizedBox(height: 24),

                  // Audio Player
                  AudioPlayerWidget(
                    arabicText: word.arabic,
                    wordId: word.id,
                    audioUrl: word.audioUrl,
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Consumer<WordProvider>(
                    builder: (context, wordProvider, child) {
                      return _buildActionButtons(context, wordProvider);
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyCard() {
    Color difficultyColor;
    String difficultyText;
    IconData difficultyIcon;

    switch (word.difficulty.toLowerCase()) {
      case 'easy':
        difficultyColor = AppColors.success;
        difficultyText = 'Oson';
        difficultyIcon = Icons.sentiment_satisfied;
        break;
      case 'medium':
        difficultyColor = AppColors.warning;
        difficultyText = 'O\'rta';
        difficultyIcon = Icons.sentiment_neutral;
        break;
      case 'hard':
        difficultyColor = AppColors.error;
        difficultyText = 'Qiyin';
        difficultyIcon = Icons.sentiment_dissatisfied;
        break;
      default:
        difficultyColor = AppColors.info;
        difficultyText = word.difficulty;
        difficultyIcon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: difficultyColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: difficultyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(difficultyIcon, color: difficultyColor, size: 28),
          const SizedBox(width: 12),
          Text(
            'Qiyinlik darajasi: $difficultyText',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: difficultyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WordProvider wordProvider) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              wordProvider.toggleFavorite(word.id);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: word.isFavorite ? Colors.red : Colors.grey,
                width: 2,
              ),
            ),
            icon: Icon(
              word.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: word.isFavorite ? Colors.red : Colors.grey,
            ),
            label: Text(
              word.isFavorite ? 'Sevimli' : 'Sevimliga qo\'sh',
              style: TextStyle(
                color: word.isFavorite ? Colors.red : Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              wordProvider.toggleLearned(word.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    word.isLearned
                        ? 'O\'rganilgan deb belgilandi'
                        : 'O\'rganilmagan deb belgilandi',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: word.isLearned ? AppColors.success : AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: Icon(
              word.isLearned ? Icons.check_circle : Icons.circle_outlined,
            ),
            label: Text(
              word.isLearned ? 'O\'rgandim' : 'O\'rgan',
            ),
          ),
        ),
      ],
    );
  }
}