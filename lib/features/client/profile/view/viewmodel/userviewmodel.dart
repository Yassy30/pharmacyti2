import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserViewModel extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  bool _isLoading = false;
  String? _fullName;
  String? _email;
  String? _phoneNumber;
  String? _address;
  String? _imageProfile;

  bool get isLoading => _isLoading;
  String? get fullName => _fullName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get address => _address;
  String? get imageProfile => _imageProfile;

  Future<void> fetchUserDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null) {
        final response = await _supabase
            .from('users')
            .select('full_name, email, phone_number, address, image_profile')
            .eq('id', userId)
            .single();

        _fullName = response['full_name'];
        _email = response['email'];
        _phoneNumber = response['phone_number'];
        _address = response['address'];
        _imageProfile = response['image_profile']; // URL or null if not set
      }
    } catch (e) {
      print('Error fetching user details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}