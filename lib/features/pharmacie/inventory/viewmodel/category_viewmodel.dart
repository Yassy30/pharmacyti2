
// lib/features/pharmacie/inventory/viewmodel/category_viewmodel.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/category.dart' as myCategory;
import 'package:pharmaciyti/features/pharmacie/inventory/data/service/supabase_service.dart';

class CategoryViewModel with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<myCategory.Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<myCategory.Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCategories() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      _categories = await _supabaseService.fetchCategories();
    } catch (e) {
      _errorMessage = _parseError(e.toString());
      if (kDebugMode) print('Fetch error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(myCategory.Category category, {File? image}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      String? imageUrl;
      if (image != null) {
        imageUrl = await _supabaseService.uploadCategoryImage(image, category.name);
      }
      final categoryWithImage = myCategory.Category(
        name: category.name,
        status: category.status,
        image: imageUrl ?? category.image,
      );
      final newCategory = await _supabaseService.addCategory(categoryWithImage);
      _categories.add(newCategory);
      if (kDebugMode) print('Added category: ${newCategory.name}');
    } catch (e) {
      _errorMessage = _parseError(e.toString());
      if (kDebugMode) print('Add error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCategory(int id, myCategory.Category category, {File? image}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      String? imageUrl;
      if (image != null) {
        imageUrl = await _supabaseService.uploadCategoryImage(category.name as File, image as String);
      }
      final categoryWithImage = myCategory.Category(
        id: id,
        name: category.name,
        status: category.status,
        image: imageUrl ?? category.image,
      );
      final updatedCategory = await _supabaseService.updateCategory(id, categoryWithImage);
      final index = _categories.indexWhere((cat) => cat.id == id);
      if (index != -1) {
        _categories[index] = updatedCategory;
      }
      if (kDebugMode) print('Updated category: ${updatedCategory.name}');
    } catch (e) {
      _errorMessage = _parseError(e.toString());
      if (kDebugMode) print('Update error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      await _supabaseService.deleteCategory(id);
      _categories.removeWhere((cat) => cat.id == id);
      if (kDebugMode) print('Deleted category with id: $id');
    } catch (e) {
      _errorMessage = _parseError(e.toString());
      if (kDebugMode) print('Delete error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _parseError(String error) {
    if (error.contains('AuthApiException') || error.contains('permission')) {
      return 'Only pharmacies can manage categories';
    } else if (error.contains('duplicate key')) {
      return 'Category name already exists';
    }
    return 'An error occurred: $error';
  }
}
