import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/category_model.dart';
import '../../providers/word_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/arabic_text.dart';
import '../../core/widgets/word_card.dart';
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
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.category.nameUz,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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

                      // Emoji
                      Text(
                        widget.category.icon,
                        style: const TextStyle(fontSize: 70),
                      ),

                      const SizedBox(height: 12),

                      // Arab nomi
                      ArabicTextMedium(
                        widget.category.nameAr,
                        color: Colors.white,
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
                      return WordCard(
                        word: word,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordDetailScreen(word: word),
                            ),
                          );
                        },
                        onFavorite: () {
                          wordProvider.toggleFavorite(word.id);
                        },
                        onLearned: () {
                          wordProvider.toggleLearned(word.id);
                        },
                      );
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
}