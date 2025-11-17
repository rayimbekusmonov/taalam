import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/category_provider.dart';
import '../../providers/word_provider.dart';
import '../category/category_screen.dart';
import '../../core/widgets/category_card.dart';
import '../quiz/quiz_menu_screen.dart';
import '../search/search_screen.dart';


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
        title: const Text('Taalam'),
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
            onPressed: () {
              final categoryProvider = context.read<CategoryProvider>();
              final wordProvider = context.read<WordProvider>();
              categoryProvider.refresh();
              wordProvider.refresh();
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
        final totalWords = wordProvider.totalWordsCount;
        final learnedWords = wordProvider.learnedWordsCount;
        final favoriteWords = wordProvider.favoriteWordsCount;

        return RefreshIndicator(
          onRefresh: () async {
            final categoryProvider = context.read<CategoryProvider>();
            final wordProvider = context.read<WordProvider>();
            categoryProvider.refresh();
            wordProvider.refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                                '${wordProvider.learningProgress.toStringAsFixed(0)}%',
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
                              value: wordProvider.learningProgress / 100,
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
                ),

                const SizedBox(height: 20),

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
                              builder: (context) => CategoryScreen(category: category),
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

            // Statistika
            _buildStatCard(
              'O\'rganilgan so\'zlar',
              '${wordProvider.learnedWordsCount}',
              Icons.check_circle,
              AppColors.success,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              'Sevimli so\'zlar',
              '${wordProvider.favoriteWordsCount}',
              Icons.favorite,
              Colors.red,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              'Jami so\'zlar',
              '${wordProvider.totalWordsCount}',
              Icons.library_books,
              AppColors.primary,
            ),

            const SizedBox(height: 24),

            // Settings buttons
            _buildSettingItem(
              'Ma\'lumotlarni yangilash',
              Icons.refresh,
                  () {
                final categoryProvider = context.read<CategoryProvider>();
                final wordProvider = context.read<WordProvider>();
                final messenger = ScaffoldMessenger.of(context);
                categoryProvider.refresh();
                wordProvider.refresh();
                messenger.showSnackBar(
                  const SnackBar(content: Text('Ma\'lumotlar yangilandi')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
