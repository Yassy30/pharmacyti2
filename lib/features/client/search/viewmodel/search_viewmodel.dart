import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pharmaciyti/features/client/home/data/models/pharmacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/medicine.dart';

class SearchViewModel extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  List<Medicine> medicines = [];
  bool isLoading = false;
  String? errorMessage;
  String? filter;
  String searchQuery = '';

  void updateSearchQuery(String query) {
    searchQuery = query;
    fetchMedicines();
  }

  void updateFilter(String? filter) {
    this.filter = filter;
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      print('Fetching medicines with query: $searchQuery, filter: $filter');
      var query = _client
          .from('medicine')
          .select('id, name, category_id, price, quantity, status, image, description, status_prescription');

      if (searchQuery.isNotEmpty) {
        query = query.ilike('name', '%$searchQuery%');
      }

      if (filter == 'Prescription') {
        query = query.eq('status_prescription', true);
      }

      final response = await query;
      print('Medicines response: $response');

      if (response.isEmpty) {
        medicines = [];
      } else {
        medicines = response
            .map((json) => Medicine.fromJson(json as Map<String, dynamic>))
            .toList();

        if (filter == 'Price') {
          medicines.sort((a, b) => a.price.compareTo(b.price));
        }
      }

      print('Parsed ${medicines.length} medicines');
    } catch (e, stackTrace) {
      errorMessage = 'Error fetching medicines: $e';
      medicines = [];
      print('$errorMessage\nStack trace: $stackTrace');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Pharmacy>> fetchPharmacies() async {
    try {
      final response = await _client
          .from('User')
          .select('id, full_name, address, phone_number, rating, is_open')
          .eq('role', 'pharmacy');

      print('Pharmacies response: $response');
      return (response as List<dynamic>)
          .map((json) => Pharmacy.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      print('Error fetching pharmacies: $e\nStack trace: $stackTrace');
      return [];
    }
  }

  Future<Map<String, dynamic>?> uploadPrescriptionImage(File image) async {
  try {
    final userId = _client.auth.currentUser?.id;
    print('Current user ID: $userId');
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final fileName = 'prescriptions/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
    print('Uploading image to: $fileName');
    final response = await _client.storage.from('prescriptions').upload(fileName, image);

    print('Storage upload response: $response');
    if (response.isEmpty) {
      throw Exception('Failed to upload image to storage');
    }

    final imageUrl = _client.storage.from('prescriptions').getPublicUrl(fileName);
    print('Image URL: $imageUrl');

    final imageData = await _client.from('prescription_images').insert({
      'user_id': userId, // Associate with the client’s user ID
      'image_url': imageUrl,
      // No pharmacy_user_id here; will be added during order creation
    }).select().single();

    print('Uploaded prescription image: $imageData');
    return imageData;
  } catch (e, stackTrace) {
    print('Error uploading prescription image: $e\nStack trace: $stackTrace');
    return null;
  }
}
  // SOLUTION 1: Check your orders table schema first
  Future<void> checkOrdersTableSchema() async {
    try {
      // This will help us see what columns exist in your orders table
      final response = await _client
          .from('orders')
          .select()
          .limit(1);
      print('Orders table structure (first row): $response');
    } catch (e) {
      print('Error checking orders table: $e');
    }
  }

  // SOLUTION 2: Updated createPrescriptionOrder with flexible column names
  Future<bool> createPrescriptionOrder(String pharmacyUserId, int prescriptionImageId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      print('Creating order for user: $userId, pharmacy: $pharmacyUserId, image: $prescriptionImageId');
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Verify prescription_image_id exists
      final imageCheck = await _client
          .from('prescription_images')
          .select('id')
          .eq('id', prescriptionImageId)
          .maybeSingle();
      if (imageCheck == null) {
        throw Exception('Invalid prescription_image_id: $prescriptionImageId');
      }

      // Try different possible column names for status
      Map<String, dynamic> orderData = {
        'user_id': userId,
        'price_total': 0.00,
        'quantity': 1,
        'prescription_image_id': prescriptionImageId,
        'pharmacy_user_id': pharmacyUserId,
      };

      // Try with different status column names
      try {
        // First try with 'status'
        orderData['statut'] = 'pending';
        orderData['type_payment'] = 'pending';
        
        final result = await _client.from('orders').insert(orderData).select().single();
        print('Created order: $result');
        return true;
      } catch (e1) {
        print('Failed with status column, trying order_status: $e1');
        
        // Remove status and try with order_status
        orderData.remove('status');
        orderData['order_status'] = 'pending';
        
        try {
          final result = await _client.from('orders').insert(orderData).select().single();
          print('Created order with order_status: $result');
          return true;
        } catch (e2) {
          print('Failed with order_status, trying without status: $e2');
          
          // Remove order_status and try without any status field
          orderData.remove('order_status');
          orderData.remove('type_payment');
          
          try {
            final result = await _client.from('orders').insert(orderData).select().single();
            print('Created order without status: $result');
            return true;
          } catch (e3) {
            print('All attempts failed: $e3');
            throw e3;
          }
        }
      }
    } catch (e, stackTrace) {
      print('Error creating prescription order: $e\nStack trace: $stackTrace');
      return false;
    }
  }

  // SOLUTION 3: Minimal order creation (most likely to work)
  Future<bool> createPrescriptionOrderMinimal(String pharmacyUserId, int prescriptionImageId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      print('Creating minimal order for user: $userId, pharmacy: $pharmacyUserId, image: $prescriptionImageId');
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Verify prescription_image_id exists
      final imageCheck = await _client
          .from('prescription_images')
          .select('id')
          .eq('id', prescriptionImageId)
          .maybeSingle();
      if (imageCheck == null) {
        throw Exception('Invalid prescription_image_id: $prescriptionImageId');
      }

      // Insert only required fields
      final orderData = await _client.from('orders').insert({
        'user_id': userId,
        'prescription_image_id': prescriptionImageId,
        'pharmacy_user_id': pharmacyUserId,
      }).select().single();

      print('Created minimal order: $orderData');
      return true;
    } catch (e, stackTrace) {
      print('Error creating minimal prescription order: $e\nStack trace: $stackTrace');
      return false;
    }
  }
  
Future<String?> getCurrentPharmacyId() async {
  try {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      print('No authenticated user found');
      return null;
    }

    // Check if the user is a pharmacy
    final pharmacyData = await _client
        .from('User')
        .select('id')
        .eq('id', userId)
        .eq('role', 'pharmacy')
        .maybeSingle();

    if (pharmacyData == null) {
      print('User is not a pharmacy');
      return null;
    }

    return userId; // Return the user's ID as the pharmacy ID if they are a pharmacy
  } catch (e, stackTrace) {
    print('Error fetching pharmacy ID: $e\nStack trace: $stackTrace');
    return null;
  }
}}