// lib/features/pharmacie/inventory/viewmodel/medicine_viewmodel.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/medicine.dart' as myMedicine;
import 'package:pharmaciyti/features/pharmacie/inventory/data/service/supabase_service.dart';

class MedicineViewModel with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<myMedicine.Medicine> _medicines = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<myMedicine.Medicine> get medicines => _medicines;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMedicines() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      _medicines = await _supabaseService.fetchMedicines();
    } catch (e) {
      _errorMessage = _parseError(e.toString());
      if (kDebugMode) print('Fetch error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMedicine(myMedicine.Medicine medicine, {File? image}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      String? imageUrl;
      if (image != null) {
        imageUrl = await _supabaseService.uploadMedicineImage(image, medicine.name);
      }
      final medicineWithImage = myMedicine.Medicine(
        name: medicine.name,
        categoryId: medicine.categoryId,
        price: medicine.price,
        quantity: medicine.quantity,
        status: medicine.status,
        image: imageUrl ?? medicine.image,
        description: medicine.description,
        statusPrescription: medicine.statusPrescription,
      );
      final newMedicine = await _supabaseService.addMedicine(medicineWithImage);
      _medicines.add(newMedicine);
      if (kDebugMode) print('Added medicine: ${newMedicine.name}');
    } catch (e) {
      _errorMessage = _parseError(e.toString());
      if (kDebugMode) print('Add error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMedicine(int id, myMedicine.Medicine medicine, {File? image}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      String? imageUrl;
      if (image != null) {
        imageUrl = await _supabaseService.uploadMedicineImage(image, medicine.name);
      }
      final medicineWithImage = myMedicine.Medicine(
        id: id,
        name: medicine.name,
        categoryId: medicine.categoryId,
        price: medicine.price,
        quantity: medicine.quantity,
        status: medicine.status,
        image: imageUrl ?? medicine.image,
        description: medicine.description,
        statusPrescription: medicine.statusPrescription,
      );
      final updatedMedicine = await _supabaseService.updateMedicine(id, medicineWithImage);
      final index = _medicines.indexWhere((med) => med.id == id);
      if (index != -1) {
        _medicines[index] = updatedMedicine;
      }
      if (kDebugMode) print('Updated medicine: ${updatedMedicine.name}');
    } catch (e) {
      _errorMessage = _parseError(e.toString());
      if (kDebugMode) print('Update error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMedicine(int id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      await _supabaseService.deleteMedicine(id);
      _medicines.removeWhere((med) => med.id == id);
      if (kDebugMode) print('Deleted medicine with id: $id');
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
      return 'Only pharmacies can manage medicines';
    } else if (error.contains('duplicate key')) {
      return 'Medicine name already exists';
    } else if (error.contains('null value in column')) {
      return 'Missing required field. Please check all inputs.';
    }
    return 'An error occurred: $error';
  }
}