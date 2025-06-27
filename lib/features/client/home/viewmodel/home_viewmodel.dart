import 'package:flutter/material.dart';
import '../data/service/supabase_service.dart';
import '../data/models/user.dart' as myUser;
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/category.dart' as myCategory;
import '../data/models/pharmacy.dart' as myPharmacy;

class HomeViewModel extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
    
  myUser.User? _user;
  List<myCategory.Category> _categories = [];
  List<myPharmacy.Pharmacy> _pharmacies = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _error;

  myUser.User? get user => _user;
  List<myCategory.Category> get categories => _categories;
  List<myPharmacy.Pharmacy> get pharmacies => _pharmacies;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get error => _error;

  HomeViewModel() {
    print('HomeViewModel initialized');
    initialize();
  }

  Future<void> initialize() async {
    print('Initializing HomeViewModel');
    _isLoading = true;
    _error = null;
    notifyListeners();
        
    try {
      await Future.wait([
        fetchUser(),
        fetchCategories(),
        fetchPharmacies(),
      ]);
      print('Initialization completed: user=$_user, categories=${_categories.length}, pharmacies=${_pharmacies.length}');
    } catch (e) {
      print('Error initializing: $e');
      _error = 'Failed to load data: $e';
    }
        
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    print('Fetching user');
    try {
      _user = await _supabaseService.getCurrentUser();
      print('User fetched: ${_user?.fullName}');
      
      // Debug profile image information
      if (_user != null) {
        print('Profile image URL: ${_user?.imageProfile}');
        // Check if the image URL is valid
        if (_user?.imageProfile != null && _user!.imageProfile!.isNotEmpty) {
          print('Profile image exists: ${_user!.imageProfile}');
        } else {
          print('No profile image found');
        }
      }
    } catch (e) {
      print('Error fetching user: $e');
      _error = 'Failed to fetch user data';
    }
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    print('Fetching categories');
    try {
      _categories = await _supabaseService.getCategories();
      print('Categories fetched: ${_categories.length}');
      
      // Debug category images
      for (var category in _categories) {
        print('Category: ${category.name}, Image: ${category.image}');
        if (category.image != null && category.image!.isNotEmpty) {
          // Validate URL format
          if (Uri.tryParse(category.image!) != null) {
            print('Valid image URL for ${category.name}');
          } else {
            print('Invalid image URL for ${category.name}: ${category.image}');
          }
        }
      }
      
      if (_categories.isEmpty) {
        print('Warning: No categories returned from Supabase');
        _error = 'No categories available';
      }
    } catch (e, stackTrace) {
      print('Error fetching categories: $e');
      print('Stack trace: $stackTrace');
      _error = 'Failed to fetch categories';
    }
    notifyListeners();
  }

  Future<void> fetchPharmacies() async {
    print('Fetching pharmacies');
    try {
      _pharmacies = await _supabaseService.getPharmacies();
      print('Pharmacies fetched: ${_pharmacies.length}');
      
      if (_pharmacies.isEmpty) {
        print('Warning: No pharmacies returned from Supabase');
        _error = 'No pharmacies available';
      }
    } catch (e) {
      print('Error fetching pharmacies: $e');
      _error = 'Failed to fetch pharmacies';
    }
    notifyListeners();
  }

  // Helper method to get profile image URL
  String? getProfileImageUrl() {
    if (_user == null) return null;
    
    // Get imageProfile from your User model
    String? imageUrl = _user?.imageProfile;
    
    // Validate URL
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (Uri.tryParse(imageUrl) != null) {
        return imageUrl;
      } else {
        print('Invalid profile image URL: $imageUrl');
      }
    }
    
    return null;
  }

  // Helper method to get category image URL with validation
  String? getCategoryImageUrl(myCategory.Category category) {
    if (category.image == null || category.image!.isEmpty) {
      return null;
    }
    
    // Validate URL
    if (Uri.tryParse(category.image!) != null) {
      return category.image;
    } else {
      print('Invalid category image URL for ${category.name}: ${category.image}');
      return null;
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> refresh() async {
    await initialize();
  }

  Future<void> signOut(BuildContext context) async {
    print('Signing out');
    try {
      await _supabaseService.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print('Sign out error: $e');
      _error = 'Failed to sign out';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}