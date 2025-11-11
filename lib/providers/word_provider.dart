import 'package:flutter/foundation.dart';
import '../models/word_model.dart';
import '../services/cache_service.dart';
import '../services/demo_data_service.dart';

class WordProvider with ChangeNotifier {
  final CacheService _cacheService = CacheService();

  List<Word> _allWords = [];
  List<Word> _currentCategoryWords = [];
  List<Word> _favoriteWords = [];
  List<Word> _learnedWords = [];

  bool _isLoading = false;
  String? _error;

  // Getters
  List<Word> get allWords => _allWords;
  List<Word> get currentCategoryWords => _currentCategoryWords;
  List<Word> get favoriteWords => _favoriteWords;
  List<Word> get learnedWords => _learnedWords;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _allWords.isNotEmpty;

  // Statistics
  int get totalWordsCount => _allWords.length;
  int get learnedWordsCount => _learnedWords.length;
  int get favoriteWordsCount => _favoriteWords.length;

  double get learningProgress {
    if (_allWords.isEmpty) return 0.0;
    return (_learnedWords.length / _allWords.length) * 100;
  }

  // Barcha so'zlarni yuklash
  Future<void> loadAllWords() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Cache'dan olish
      _allWords = await _cacheService.getAllWords();

      // Agar cache bo'sh bo'lsa, demo data yuklash
      if (_allWords.isEmpty) {
        await loadDemoData();
      }

      // Favorite va learned so'zlarni yangilash
      await _updateFavoriteAndLearnedLists();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'So\'zlarni yuklashda xatolik: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Demo ma'lumotlarni yuklash
  Future<void> loadDemoData() async {
    try {
      final demoWords = DemoDataService.getDemoWords();
      await _cacheService.saveWords(demoWords);
      _allWords = demoWords;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading demo words: $e');
      }
    }
  }

  // Kategoriya bo'yicha so'zlarni yuklash
  Future<void> loadWordsByCategory(String categoryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentCategoryWords = await _cacheService.getWordsByCategory(categoryId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Kategoriya so\'zlarini yuklashda xatolik: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Favorite va learned listlarni yangilash
  Future<void> _updateFavoriteAndLearnedLists() async {
    try {
      _favoriteWords = _allWords.where((word) => word.isFavorite).toList();
      _learnedWords = _allWords.where((word) => word.isLearned).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating lists: $e');
      }
    }
  }

  // So'zni sevimliga qo'shish/olib tashlash
  Future<void> toggleFavorite(String wordId) async {
    try {
      // _allWords ichidan topish
      final wordIndex = _allWords.indexWhere((w) => w.id == wordId);
      if (wordIndex == -1) return;

      // Toggle qilish
      _allWords[wordIndex].isFavorite = !_allWords[wordIndex].isFavorite;

      // Cache'ga saqlash
      await _cacheService.updateWord(_allWords[wordIndex]);

      // Current category words'ni ham yangilash
      final categoryWordIndex = _currentCategoryWords.indexWhere((w) => w.id == wordId);
      if (categoryWordIndex != -1) {
        _currentCategoryWords[categoryWordIndex].isFavorite = _allWords[wordIndex].isFavorite;
      }

      // Listlarni yangilash
      await _updateFavoriteAndLearnedLists();

      notifyListeners();
    } catch (e) {
      _error = 'Sevimliga qo\'shishda xatolik: $e';
      notifyListeners();
    }
  }

  // So'zni o'rganilgan deb belgilash
  Future<void> toggleLearned(String wordId) async {
    try {
      // _allWords ichidan topish
      final wordIndex = _allWords.indexWhere((w) => w.id == wordId);
      if (wordIndex == -1) return;

      // Toggle qilish
      _allWords[wordIndex].isLearned = !_allWords[wordIndex].isLearned;

      // Cache'ga saqlash
      await _cacheService.updateWord(_allWords[wordIndex]);

      // Current category words'ni ham yangilash
      final categoryWordIndex = _currentCategoryWords.indexWhere((w) => w.id == wordId);
      if (categoryWordIndex != -1) {
        _currentCategoryWords[categoryWordIndex].isLearned = _allWords[wordIndex].isLearned;
      }

      // Listlarni yangilash
      await _updateFavoriteAndLearnedLists();

      notifyListeners();
    } catch (e) {
      _error = 'O\'rganilgan deb belgilashda xatolik: $e';
      notifyListeners();
    }
  }

  // So'zni ID bo'yicha olish
  Word? getWordById(String id) {
    try {
      return _allWords.firstWhere((word) => word.id == id);
    } catch (e) {
      return null;
    }
  }

  // Qidiruv
  List<Word> searchWords(String query) {
    if (query.isEmpty) return _allWords;

    final lowerQuery = query.toLowerCase();
    return _allWords.where((word) {
      return word.uzbek.toLowerCase().contains(lowerQuery) ||
          word.english.toLowerCase().contains(lowerQuery) ||
          word.arabic.contains(query) ||
          word.transliteration.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Kategoriya bo'yicha statistika
  Map<String, int> getCategoryStatistics(String categoryId) {
    final categoryWords = _allWords.where((w) => w.categoryId == categoryId).toList();
    final learnedCount = categoryWords.where((w) => w.isLearned).length;

    return {
      'total': categoryWords.length,
      'learned': learnedCount,
      'remaining': categoryWords.length - learnedCount,
    };
  }

  // Qiyinlik darajasi bo'yicha statistika
  Map<String, int> getDifficultyStatistics() {
    return {
      'easy': _allWords.where((w) => w.difficulty == 'easy').length,
      'medium': _allWords.where((w) => w.difficulty == 'medium').length,
      'hard': _allWords.where((w) => w.difficulty == 'hard').length,
    };
  }

  // Cache'ni tozalash va qayta yuklash
  Future<void> resetProgress() async {
    try {
      // Barcha so'zlarni reset qilish
      for (var word in _allWords) {
        word.isFavorite = false;
        word.isLearned = false;
        await _cacheService.updateWord(word);
      }

      // Listlarni yangilash
      await _updateFavoriteAndLearnedLists();

      notifyListeners();
    } catch (e) {
      _error = 'Progressni reset qilishda xatolik: $e';
      notifyListeners();
    }
  }

  // Yangilash
  Future<void> refresh() async {
    await loadAllWords();
  }
}