// lib/features/pharmacy/viewmodel/pharmacy_viewmodel.dart
import 'dart:core';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PharmacyViewModel with ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  String? _fullName;
  String? _email;
  String? _phoneNumber;
  String? _address;
  String? _imageProfile;
  double? _rating;
  bool? _isOpen;
  bool _isLoading = false;
  String? _errorMessage;

  String? get fullName => _fullName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get address => _address;
  String? get imageProfile => _imageProfile;
  double? get rating => _rating;
  bool? get isOpen => _isOpen;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPharmacyDetails() async {
    try {
      _isLoading = true;
      notifyListeners();

      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        _errorMessage = 'No authenticated user found';
        return;
      }

      final response = await _client
          .from('User')
          .select('full_name, email, phone_number, address, image_profile, rating, is_open')
          .eq('id', userId)
          .eq('role', 'pharmacy')
          .single();

      _fullName = response['full_name'];
      _email = response['email'];
      _phoneNumber = response['phone_number'];
      _address = response['address'];
      _imageProfile = response['image_profile'];
      _rating = (response['rating'] as num?)?.toDouble();
      _isOpen = response['is_open'] as bool?;

      if (kDebugMode) print('Pharmacy Image URL: $_imageProfile');
    } catch (e) {
      _errorMessage = 'Failed to fetch pharmacy details: $e';
      if (kDebugMode) print('Fetch pharmacy error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePharmacyDetails({
    String? fullName,
    String? phoneNumber,
    String? address,
    String? imageProfile,
    double? rating,
    bool? isOpen,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        _errorMessage = 'No authenticated user found';
        return false;
      }

      final updates = {
        if (fullName != null) 'full_name': fullName,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (address != null) 'address': address,
        if (imageProfile != null) 'image_profile': imageProfile,
        if (rating != null) 'rating': rating,
        if (isOpen != null) 'is_open': isOpen,
      };

      if (updates.isNotEmpty) {
        await _client.from('User').update(updates).eq('id', userId).eq('role', 'pharmacy');
        await fetchPharmacyDetails(); // Refresh data after update
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update pharmacy: $e';
      if (kDebugMode) print('Update pharmacy error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> isProfileComplete() async {
    await fetchPharmacyDetails();
    return _fullName != null &&
        _fullName!.isNotEmpty &&
        _phoneNumber != null &&
        _phoneNumber!.isNotEmpty &&
        _address != null &&
        _address!.isNotEmpty &&
        _rating != null &&
        _isOpen != null;
  }
}