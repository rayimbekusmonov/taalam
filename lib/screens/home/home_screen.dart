import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/category_provider.dart';
import '../../providers/word_provider.dart';
import '../category/category_screen.dart';
import '../../widgets/progress_card.dart';
import '../search/search_screen.dart';
import '../../core/widgets/category_card.dart';
import '../../screens/quiz/quiz_menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategories();
      context.read<WordProvider>().loadAllWords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ArabLug\'at'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final categoryProvider = context.read<CategoryProvider>();
              final wordProvider = context.read<WordProvider>();
              categoryProvider.refresh();
              await wordProvider.refresh();
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildCategoriesTab();
      case 1:
        return _buildFavoritesTab();
      case 2:
        return _buildQuizTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildCategoriesTab();
    }
  }

  Widget _buildCategoriesTab() {
    return Consumer2<CategoryProvider, WordProvider>(
      builder: (context, categoryProvider, wordProvider, child) {
        if (categoryProvider.isLoading || wordProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (categoryProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(categoryProvider.error!),
                ElevatedButton(
                  onPressed: () => categoryProvider.refresh(),
                  child: const Text('Qayta urinish'),
                ),
              ],
            ),
          );
        }

        final categories = categoryProvider.categories;

        return RefreshIndicator(
          onRefresh: () async {
            context.read<CategoryProvider>().refresh();
            await context.read<WordProvider>().refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Card
                ProgressCard(
                  learnedWords: wordProvider.learnedWordsCount,
                  totalWords: wordProvider.totalWordsCount,
                  favoriteWords: wordProvider.favoriteWordsCount,
                  progress: wordProvider.learningProgress,
                ),

                const SizedBox(height: 20),

                // Kategoriyalar sarlavhasi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kategoriyalar',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        '${categories.length} ta',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Kategoriyalar grid
                categories.isEmpty
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('Hozircha kategoriya yo\'q'),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final color = AppColors.categoryColors[
                      index % AppColors.categoryColors.length];

                      final categoryWordsCount = wordProvider.allWords
                          .where((w) => w.categoryId == category.id)
                          .length;

                      return CategoryCard(
                        category: category,
                        wordsCount: categoryWordsCount,
                        color: color,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoryScreen(category: category),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoritesTab() {
    return Consumer<WordProvider>(
      builder: (context, wordProvider, child) {
        final favorites = wordProvider.favoriteWords;

        if (wordProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Sevimli so\'zlar yo\'q',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'So\'zlarni sevimliga qo\'shing',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final word = favorites[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Text(
                  word.emoji ?? '📝',
                  style: const TextStyle(fontSize: 32),
                ),
                title: Text(
                  word.arabic,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(word.uzbek),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    wordProvider.toggleFavorite(word.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }


  Widget _buildQuizTab() {
    return const QuizMenuScreen();
  }

  Widget _buildProfileTab() {
    return Consumer<WordProvider>(
      builder: (context, wordProvider, child) {
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Foydalanuvchi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Detailed Statistics
            DetailedStatsCard(
              stats: {
                'learned': wordProvider.learnedWordsCount,
                'favorites': wordProvider.favoriteWordsCount,
                'total': wordProvider.totalWordsCount,
              },
            ),

            const SizedBox(height: 24),

            // Settings section
            Text(
              'Sozlamalar',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),

            _buildSettingItem(
              'Ma\'lumotlarni yangilash',
              Icons.refresh,
                  () async {
                final categoryProvider = context.read<CategoryProvider>();
                final wordProvider = context.read<WordProvider>();
                final messenger = ScaffoldMessenger.of(context);

                categoryProvider.refresh();
                await wordProvider.refresh();

                messenger.showSnackBar(
                  const SnackBar(content: Text('Ma\'lumotlar yangilandi')),
                );
              },
            ),

            _buildSettingItem(
              'Progressni tozalash',
              Icons.delete_outline,
                  () async {
                // Tasdiqlash dialogi
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Progressni tozalash'),
                    content: const Text(
                      'Barcha o\'rganilgan va sevimli so\'zlar tozalanadi. Davom etasizmi?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Yo\'q'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        child: const Text('Ha, tozalash'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && context.mounted) {
                  final wordProvider = context.read<WordProvider>();
                  final messenger = ScaffoldMessenger.of(context);

                  await wordProvider.resetProgress();

                  messenger.showSnackBar(
                    const SnackBar(content: Text('Progress tozalandi')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingItem(String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Asosiy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Sevimli',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined),
            activeIcon: Icon(Icons.quiz),
            label: 'Test',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}