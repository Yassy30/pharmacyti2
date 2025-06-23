
// supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart' as myUser;
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/category.dart' as myCategory;
import '../models/pharmacy.dart' as myPharmacy;

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Fetch logged-in user's data
  Future<myUser.User?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        print('No authenticated user found');
        return null;
      }

      print('Fetching user data for ID: ${user.id}');
      
      final response = await _client
          .from('User')
          .select('id, full_name, address, image_profile')
          .eq('id', user.id)
          .single();

      print('User response: $response');
      
      if (response == null) {
        print('No user data found in database');
        return null;
      }

      return myUser.User.fromJson(response);
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // Fetch categories
Future<List<myCategory.Category>> getCategories() async {
  try {
    print('Fetching categories...');
    final response = await _client
        .from('category')
        .select('id, name, image, status'); // Include status for debugging

    print('Categories response: $response');

    if (response is! List || response.isEmpty) {
      print('No categories found');
      return [];
    }

    final categories = response
        .map((json) => myCategory.Category.fromJson(json as Map<String, dynamic>))
        .toList();
    
    print('Parsed ${categories.length} categories: $categories');
    return categories;
  } catch (e) {
    print('Error fetching categories: $e');
    return [];
  }
}

  // Fetch pharmacies
  Future<List<myPharmacy.Pharmacy>> getPharmacies() async {
    try {
      print('Fetching pharmacies...');
      
      final response = await _client
          .from('User')
          .select('id, full_name, address, phone_number')
          .eq('role', 'pharmacy');

      print('Pharmacies response: $response');

      if (response == null) {
        print('No pharmacies found');
        return [];
      }

      final pharmacies = (response as List)
          .map((json) => myPharmacy.Pharmacy.fromJson(json))
          .toList();
      
      print('Parsed ${pharmacies.length} pharmacies');
      return pharmacies;
    } catch (e) {
      print('Error fetching pharmacies: $e');
      return [];
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }
}