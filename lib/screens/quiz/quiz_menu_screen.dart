import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/word_provider.dart';
import '../../providers/category_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../services/quiz_service.dart';
import 'flashcard_screen.dart';
import 'multiple_choice_screen.dart';

class QuizMenuScreen extends StatelessWidget {
  const QuizMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test rejimi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Icon(Icons.quiz, size: 60, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Bilimingizni sinab ko\'ring!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Test turini tanlang',
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          const SizedBox(height: 16),

          // Flashcard
          _buildQuizTypeCard(
            context,
            'Flashcard',
            'So\'zlarni karta shaklida o\'rganing',
            Icons.style,
            AppColors.primary,
                () => _startFlashcard(context),
          ),

          // Multiple Choice
          _buildQuizTypeCard(
            context,
            'Testlar',
            'Ko\'p variantli savollar',
            Icons.quiz_outlined,
            AppColors.secondary,
                () => _showQuizOptions(context),
          ),

          // Category Quiz
          _buildQuizTypeCard(
            context,
            'Kategoriya bo\'yicha',
            'Biror kategoriyani tanlang',
            Icons.category,
            AppColors.success,
                () => _selectCategory(context),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizTypeCard(
      BuildContext context,
      String title,
      String description,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _startFlashcard(BuildContext context) {
    final wordProvider = context.read<WordProvider>();
    final quizService = QuizService();

    final flashcards = quizService.generateFlashcards(wordProvider.allWords);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardScreen(
          words: flashcards,
          title: 'Flashcard',
        ),
      ),
    );
  }

  void _showQuizOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Savol sonini tanlang',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            _buildQuestionCountOption(context, 5),
            _buildQuestionCountOption(context, 10),
            _buildQuestionCountOption(context, 15),
            _buildQuestionCountOption(context, 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCountOption(BuildContext context, int count) {
    return ListTile(
      leading: const Icon(Icons.quiz),
      title: Text('$count ta savol'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.pop(context);
        _startMultipleChoice(context, count);
      },
    );
  }

  void _startMultipleChoice(BuildContext context, int count) {
    final wordProvider = context.read<WordProvider>();
    final quizService = QuizService();

    final questions = quizService.generateMultipleChoice(
      wordProvider.allWords,
      count,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultipleChoiceScreen(
          questions: questions,
          title: '$count ta savollik test',
        ),
      ),
    );
  }

  void _selectCategory(BuildContext context) {
    final categoryProvider = context.read<CategoryProvider>();

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Kategoriyani tanlang',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ...categoryProvider.categories.map((category) {
              return ListTile(
                leading: Text(category.icon, style: const TextStyle(fontSize: 24)),
                title: Text(category.nameUz),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  _startCategoryQuiz(context, category.id, category.nameUz);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _startCategoryQuiz(BuildContext context, String categoryId, String categoryName) {
    final wordProvider = context.read<WordProvider>();
    final categoryWords = wordProvider.allWords
        .where((w) => w.categoryId == categoryId)
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardScreen(
          words: categoryWords,
          title: categoryName,
        ),
      ),
    );
  }
}