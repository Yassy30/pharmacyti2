import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/medicine.dart';

class SearchViewModel extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  List<Medicine> medicines = [];
  bool isLoading = false;
  String? errorMessage;
  String? selectedFilter;
  String searchQuery = '';

  void updateSearchQuery(String query) {
    searchQuery = query;
    fetchMedicines();
  }

  void updateFilter(String? filter) {
    selectedFilter = filter;
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      print('Fetching medicines with query: $searchQuery, filter: $selectedFilter');

      // Build the query
      var query = _client
          .from('medicine')
          .select('id, name, category_id, price, quantity, status, image, description, status_prescription');

      // Apply search query (case-insensitive)
      if (searchQuery.isNotEmpty) {
        query = query.ilike('name', '%$searchQuery%');
      }

      // Apply filters
      if (selectedFilter == 'Prescription') {
        query = query.eq('status_prescription', true);
      }
      // Note: Price filter is handled after fetching
      // Rating and Distance are placeholders (require additional fields/logic)

      final response = await query;

      print('Medicines response: $response');

      if (response.isEmpty) {
        medicines = [];
      } else {
        medicines = response
            .map((json) => Medicine.fromJson(json as Map<String, dynamic>))
            .toList();

        // Apply Price filter in-memory
        if (selectedFilter == 'Price') {
          medicines.sort((a, b) => a.price.compareTo(b.price));
        }
      }

      print('Parsed ${medicines.length} medicines');
    } catch (e) {
      errorMessage = 'Error fetching medicines: $e';
      medicines = [];
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}