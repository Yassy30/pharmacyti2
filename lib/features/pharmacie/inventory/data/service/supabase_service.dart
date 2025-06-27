// lib/features/pharmacie/inventory/data/service/supabase_service.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/category.dart' as myCategory;
import 'package:pharmaciyti/features/pharmacie/inventory/data/models/medicine.dart' as myMedicine;

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  // Category Methods
  Future<List<myCategory.Category>> fetchCategories() async {
    try {
      final response = await client
          .from('category')
          .select()
          .order('id', ascending: true);
      return response.map((json) => myCategory.Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<myCategory.Category> addCategory(myCategory.Category category) async {
    try {
      print('Inserting category: ${category.toJson()}');
      final response = await client
          .from('category')
          .insert(category.toJson())
          .select()
          .single();
      print('Insert response data: $response');
      return myCategory.Category.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  Future<myCategory.Category> updateCategory(int id, myCategory.Category category) async {
    try {
      final response = await client
          .from('category')
          .update(category.toJson())
          .eq('id', id)
          .select()
          .single();
      return myCategory.Category.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      final category = await client
          .from('category')
          .select('image')
          .eq('id', id)
          .single();
      if (category['image'] != null) {
        final fileName = category['image'].split('/').last;
        await client.storage.from('categoryimages').remove([fileName]);
        print('Deleted image: $fileName');
      }
      await client.from('category').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  Future<String?> uploadCategoryImage(File image, String categoryName) async {
    try {
      final fileName = '${categoryName}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      print('Uploading category image to bucket: categoryimages, file: $fileName');
      final response = await client.storage
          .from('categoryimages')
          .upload(fileName, image);
      if (response.isEmpty) throw Exception('Upload failed: No response data');
      final publicUrl = client.storage.from('categoryimages').getPublicUrl(fileName);
      print('Category image uploaded: $publicUrl');
      return publicUrl;
    } on StorageException catch (e) {
      if (e.statusCode == '403') {
        throw Exception('Unauthorized: Only pharmacy users can upload images.');
      } else if (e.statusCode == '404') {
        throw Exception('Storage bucket "categoryimages" not found.');
      }
      throw Exception('Failed to upload category image: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload category image: $e');
    }
  }

  // Medicine Methods
  Future<List<myMedicine.Medicine>> fetchMedicines() async {
    try {
      final response = await client
          .from('medicine')
          .select()
          .order('id', ascending: true);
      return response.map((json) => myMedicine.Medicine.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch medicines: $e');
    }
  }

  Future<myMedicine.Medicine> addMedicine(myMedicine.Medicine medicine) async {
  try {
    print('Inserting medicine: ${medicine.toJson()}');
    final response = await client
        .from('medicine')
        .insert(medicine.toJson())
        .select()
        .single();
    print('Insert response data: $response');
    return myMedicine.Medicine.fromJson(response);
  } catch (e) {
    throw Exception('Failed to add medicine: $e');
  }
}

  Future<myMedicine.Medicine> updateMedicine(int id, myMedicine.Medicine medicine) async {
    try {
      final response = await client
          .from('medicine')
          .update(medicine.toJson())
          .eq('id', id)
          .select()
          .single();
      return myMedicine.Medicine.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update medicine: $e');
    }
  }

  Future<void> deleteMedicine(int id) async {
    try {
      final medicine = await client
          .from('medicine')
          .select('image')
          .eq('id', id)
          .single();
      if (medicine['image'] != null) {
        final fileName = medicine['image'].split('/').last;
        await client.storage.from('medicineimages').remove([fileName]);
        print('Deleted medicine image: $fileName');
      }
      await client.from('medicine').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete medicine: $e');
    }
  }

  Future<String?> uploadMedicineImage(File image, String medicineName) async {
    try {
      final fileName = '${medicineName}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      print('Uploading medicine image to bucket: medicineimages, file: $fileName');
      final response = await client.storage
          .from('medicineimages')
          .upload(fileName, image);
      if (response.isEmpty) throw Exception('Upload failed: No response data');
      final publicUrl = client.storage.from('medicineimages').getPublicUrl(fileName);
      print('Medicine image uploaded: $publicUrl');
      return publicUrl;
    } on StorageException catch (e) {
      if (e.statusCode == '403') {
        throw Exception('Unauthorized: Only pharmacy users can upload images.');
      } else if (e.statusCode == '404') {
        throw Exception('Storage bucket "medicine_images" not found.');
      }
      throw Exception('Failed to upload medicine image: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload medicine image: $e');
    }
  }
}