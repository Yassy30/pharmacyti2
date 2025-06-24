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

  myUser.User? get user => _user;
  List<myCategory.Category> get categories => _categories;
  List<myPharmacy.Pharmacy> get pharmacies => _pharmacies;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  HomeViewModel() {
    print('HomeViewModel initialized');
    initialize();
  }

  Future<void> initialize() async {
    print('Initializing HomeViewModel');
    _isLoading = true;
    notifyListeners();
    
    try {
      await Future.wait([
        fetchUser(),
        fetchCategories(),
        fetchPharmacies(),
      ]);
      print('Initialization completed: user=$_user, categories=$_categories, pharmacies=$_pharmacies');
    } catch (e) {
      print('Error initializing: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    print('Fetching user');
    try {
      _user = await _supabaseService.getCurrentUser();
      print('User fetched: $_user');
    } catch (e) {
      print('Error fetching user: $e');
    }
    notifyListeners();
  }

  Future<void> fetchCategories() async {
  print('Fetching categories');
  try {
    _categories = await _supabaseService.getCategories();
    print('Categories fetched: $_categories');
    if (_categories.isEmpty) {
      print('Warning: No categories returned from Supabase');
    }
  } catch (e, stackTrace) {
    print('Error fetching categories: $e');
    print('Stack trace: $stackTrace');
  }
  notifyListeners();
}

  Future<void> fetchPharmacies() async {
    print('Fetching pharmacies');
    try {
      _pharmacies = await _supabaseService.getPharmacies();
      print('Pharmacies fetched: $_pharmacies');
    } catch (e) {
      print('Error fetching pharmacies: $e');
    }
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
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
    }
  }
}