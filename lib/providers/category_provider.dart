import 'package:flutter/foundation.dart' hide Category;
import '../models/category_model.dart';
import '../services/cache_service.dart';
import '../services/demo_data_service.dart';

class CategoryProvider with ChangeNotifier {
  final CacheService _cacheService = CacheService();

  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _categories.isNotEmpty;

  // Kategoriyalarni yuklash
  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Cache'dan olish
      _categories = await _cacheService.getAllCategories();

      // Agar cache bo'sh bo'lsa, demo data yuklash
      if (_categories.isEmpty) {
        await loadDemoData();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Kategoriyalarni yuklashda xatolik: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Demo ma'lumotlarni yuklash
  Future<void> loadDemoData() async {
    try {
      final demoCategories = DemoDataService.getDemoCategories();
      await _cacheService.saveCategories(demoCategories);
      _categories = demoCategories;
      notifyListeners();
    } catch (e) {
      print('Error loading demo categories: $e');
    }
  }

  // Kategoriyani ID bo'yicha olish
  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  // Kategoriya qo'shish
  Future<void> addCategory(Category category) async {
    try {
      await _cacheService.saveCategory(category);
      _categories.add(category);
      _categories.sort((a, b) => a.order.compareTo(b.order));
      notifyListeners();
    } catch (e) {
      _error = 'Kategoriya qo\'shishda xatolik: $e';
      notifyListeners();
    }
  }

  // Kategoriyani yangilash
  Future<void> updateCategory(Category category) async {
    try {
      await _cacheService.saveCategory(category);
      final index = _categories.indexWhere((cat) => cat.id == category.id);
      if (index != -1) {
        _categories[index] = category;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Kategoriyani yangilashda xatolik: $e';
      notifyListeners();
    }
  }

  // Kategoriyani o'chirish
  Future<void> deleteCategory(String id) async {
    try {
      await _cacheService.deleteCategory(id);
      _categories.removeWhere((cat) => cat.id == id);
      notifyListeners();
    } catch (e) {
      _error = 'Kategoriyani o\'chirishda xatolik: $e';
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadCategories();
  }
}