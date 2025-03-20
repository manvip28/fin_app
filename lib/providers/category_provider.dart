// lib/providers/category_provider.dart
import 'package:flutter/foundation.dart' hide Category;
import '../models/category.dart';
import '../services/database_service.dart';

class CategoryProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<Category> _categories = [];
  List<Category> get categories => [..._categories];

  Future<void> loadCategories() async {
    _categories = await _db.getCategories();
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    final id = await _db.insertCategory(category);
    _categories.add(category.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateCategory(Category category) async {
    await _db.updateCategory(category);

    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String id) async {
    await _db.deleteCategory(id);
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
  }

  Category? getCategoryById(String id) {
    return _categories.firstWhere(
          (category) => category.id == id,
      orElse: () => Category(id: '', name: 'Unknown', icon: '', color: ''),
    );
  }


  String getCategoryNameById(String id) {
    return _categories.firstWhere((category) => category.id == id, orElse: () => Category(name: 'Unknown', icon: '', color: '')).name;
  }
}