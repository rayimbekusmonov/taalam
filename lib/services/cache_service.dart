import 'package:flutter/foundation.dart' hide Category;
import 'package:hive/hive.dart';
import '../models/category_model.dart';
import '../models/word_model.dart';
import '../models/user_progress_model.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  // Box'larni olish
  Box<Category> get _categoryBox => Hive.box<Category>('categories');
  Box<Word> get _wordBox => Hive.box<Word>('words');
  Box<UserProgress> get _userProgressBox => Hive.box<UserProgress>('userProgress');

  // ==================== CATEGORIES ====================

  // Barcha kategoriyalarni olish
  Future<List<Category>> getAllCategories() async {
    try {
      final categories = _categoryBox.values.toList();
      categories.sort((a, b) => a.order.compareTo(b.order));
      return categories;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting categories: $e');
      }
      return [];
    }
  }

  // Kategoriyani ID bo'yicha olish
  Future<Category?> getCategoryById(String id) async {
    try {
      return _categoryBox.get(id);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting category by ID: $e');
      }
      return null;
    }
  }

  // Kategoriyani saqlash
  Future<void> saveCategory(Category category) async {
    try {
      await _categoryBox.put(category.id, category);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving category: $e');
      }
    }
  }

  // Bir nechta kategoriyalarni saqlash
  Future<void> saveCategories(List<Category> categories) async {
    try {
      final Map<String, Category> categoryMap = {
        for (var category in categories) category.id: category
      };
      await _categoryBox.putAll(categoryMap);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving categories: $e');
      }
    }
  }

  // Kategoriyani o'chirish
  Future<void> deleteCategory(String id) async {
    try {
      await _categoryBox.delete(id);
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting category: $e');
      }
    }
  }

  // ==================== WORDS ====================

  // Barcha so'zlarni olish
  Future<List<Word>> getAllWords() async {
    try {
      return _wordBox.values.toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting all words: $e');
      }
      return [];
    }
  }

  // Kategoriya bo'yicha so'zlarni olish
  Future<List<Word>> getWordsByCategory(String categoryId) async {
    try {
      final words = _wordBox.values
          .where((word) => word.categoryId == categoryId)
          .toList();
      return words;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting words by category: $e');
      }
      return [];
    }
  }

  // So'zni ID bo'yicha olish
  Future<Word?> getWordById(String id) async {
    try {
      return _wordBox.get(id);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting word by ID: $e');
      }
      return null;
    }
  }

  // So'zni saqlash
  Future<void> saveWord(Word word) async {
    try {
      await _wordBox.put(word.id, word);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving word: $e');
      }
    }
  }

  // Bir nechta so'zlarni saqlash
  Future<void> saveWords(List<Word> words) async {
    try {
      final Map<String, Word> wordMap = {
        for (var word in words) word.id: word
      };
      await _wordBox.putAll(wordMap);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving words: $e');
      }
    }
  }

  // So'zni yangilash (favorite, learned)
  Future<void> updateWord(Word word) async {
    try {
      await _wordBox.put(word.id, word);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating word: $e');
      }
    }
  }

  // Sevimli so'zlarni olish
  Future<List<Word>> getFavoriteWords() async {
    try {
      final words = _wordBox.values
          .where((word) => word.isFavorite)
          .toList();
      return words;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting favorite words: $e');
      }
      return [];
    }
  }

  // O'rganilgan so'zlarni olish
  Future<List<Word>> getLearnedWords() async {
    try {
      final words = _wordBox.values
          .where((word) => word.isLearned)
          .toList();
      return words;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting learned words: $e');
      }
      return [];
    }
  }

  // So'zni o'chirish
  Future<void> deleteWord(String id) async {
    try {
      await _wordBox.delete(id);
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting word: $e');
      }
    }
  }

  // ==================== USER PROGRESS ====================

  // Foydalanuvchi progressini olish
  Future<UserProgress?> getUserProgress(String userId) async {
    try {
      return _userProgressBox.get(userId);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user progress: $e');
      }
      return null;
    }
  }

  // Foydalanuvchi progressini saqlash
  Future<void> saveUserProgress(UserProgress progress) async {
    try {
      await _userProgressBox.put(progress.wordId, progress);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user progress: $e');
      }
    }
  }

  // ==================== UTILITY ====================

  // Cache'ni tozalash
  Future<void> clearAllCache() async {
    try {
      await _categoryBox.clear();
      await _wordBox.clear();
      await _userProgressBox.clear();
      if (kDebugMode) {
        print('✅ All cache cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing cache: $e');
      }
    }
  }

  // Cache hajmini olish
  int getCacheSize() {
    return _categoryBox.length + _wordBox.length + _userProgressBox.length;
  }

  // Ma'lumotlar borligini tekshirish
  bool hasData() {
    return _categoryBox.isNotEmpty || _wordBox.isNotEmpty;
  }

  // Last update vaqtini olish
  DateTime? getLastUpdateTime() {
    final categories = _categoryBox.values.toList();
    if (categories.isEmpty) return null;

    categories.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    return categories.first.lastUpdated;
  }
}