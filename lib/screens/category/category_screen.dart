import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/category_model.dart';
import '../../models/word_model.dart';
import '../../providers/word_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../word_detail/word_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;

  const CategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    // Kategoriya so'zlarini yuklash
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WordProvider>().loadWordsByCategory(widget.category.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.category.nameUz,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(100, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        widget.category.icon,
                        style: const TextStyle(fontSize: 80),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.category.nameAr,
                        style: AppTheme.arabicMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // So'zlar ro'yxati
          Consumer<WordProvider>(
            builder: (context, wordProvider, child) {
              if (wordProvider.isLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final words = wordProvider.currentCategoryWords;

              if (words.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Bu kategoriyada so\'z yo\'q',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final word = words[index];
                      return _buildWordCard(word, wordProvider);
                    },
                    childCount: words.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard(Word word, WordProvider wordProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WordDetailScreen(word: word),
            ),
          );
        },
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
                    // Arabic text
                    Text(
                      word.arabic,
                      style: AppTheme.arabicMedium.copyWith(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Transliteration
                    Text(
                      word.transliteration,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Meaning
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
                children: [
                  // Favorite button
                  IconButton(
                    icon: Icon(
                      word.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: word.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      wordProvider.toggleFavorite(word.id);
                    },
                  ),

                  // Learned button
                  IconButton(
                    icon: Icon(
                      word.isLearned ? Icons.check_circle : Icons.circle_outlined,
                      color: word.isLearned ? AppColors.success : Colors.grey,
                    ),
                    onPressed: () {
                      wordProvider.toggleLearned(word.id);
                    },
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