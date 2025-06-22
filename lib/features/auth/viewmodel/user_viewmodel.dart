import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserViewModel with ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  String? _fullName;
  String? _email;
  String? _phoneNumber;
  String? _address;
  String? _imageProfile;
  bool _isLoading = false;
  String? _errorMessage;

  String? get fullName => _fullName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get address => _address;
  String? get imageProfile => _imageProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  get username => null;
  
Future<void> fetchUserDetails() async {
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
        .select('full_name, phone_number, address, image_profile')
        .eq('id', userId)
        .single();

    _fullName = response['full_name'];
    _phoneNumber = response['phone_number'];
    _address = response['address'];
    _imageProfile = response['image_profile'];
    
    // Debug log
    if (kDebugMode) print('Image URL: $_imageProfile');
    
  } catch (e) {
    _errorMessage = 'Failed to fetch user details: $e';
    if (kDebugMode) print('Fetch error: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<bool> updateUserDetails({
    String? fullName,
    String? phoneNumber,
    String? address,
    String? imageProfile,
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
      };

      if (updates.isNotEmpty) {
        await _client.from('User').update(updates).eq('id', userId);
        await fetchUserDetails(); // Refresh data after update
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update user: $e';
      if (kDebugMode) print('Update user error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> isProfileComplete() async {
    await fetchUserDetails();
    return _fullName != null &&
        _fullName!.isNotEmpty &&
        _phoneNumber != null &&
        _phoneNumber!.isNotEmpty &&
        _address != null &&
        _address!.isNotEmpty;
  }
}