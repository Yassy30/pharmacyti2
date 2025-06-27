// lib/features/auth/viewmodel/user_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserViewModel with ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;
  
  // User data
  String? _fullName;
  String? _email;
  String? _phoneNumber;
  String? _address;
  String? _imageProfile;
  String? _role;
  
  // Loading states
  bool _isLoading = false;
  bool _isUpdating = false;
  
  // Error handling
  String? _errorMessage;

  // Getters
  String? get fullName => _fullName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get address => _address;
  String? get imageProfile => _imageProfile;
  String? get role => _role;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Check if user is authenticated
  bool get isAuthenticated => _client.auth.currentUser != null;
  String? get currentUserId => _client.auth.currentUser?.id;

  Future<void> fetchUserDetails() async {
    if (!isAuthenticated) {
      _errorMessage = 'No authenticated user found';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _client
          .from('User')
          .select('full_name, email, phone_number, address, image_profile, role')
          .eq('id', currentUserId!)
          .single();

      _fullName = response['full_name'];
      _email = response['email'];
      _phoneNumber = response['phone_number'];
      _address = response['address'];
      _imageProfile = response['image_profile'];
      _role = response['role'];

      if (kDebugMode) {
        print('Fetched user details successfully');
        print('User role: $_role');
        print('Image URL: $_imageProfile');
      }
    } on PostgrestException catch (e) {
      _errorMessage = 'Database error: ${e.message}';
      if (kDebugMode) print('PostgrestException: ${e.message}');
    } catch (e) {
      _errorMessage = 'Failed to fetch user details: ${e.toString()}';
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
    if (!isAuthenticated) {
      _errorMessage = 'No authenticated user found';
      notifyListeners();
      return false;
    }

    try {
      _isUpdating = true;
      _errorMessage = null;
      notifyListeners();

      final updates = <String, dynamic>{};
      
      if (fullName != null && fullName.trim().isNotEmpty) {
        updates['full_name'] = fullName.trim();
      }
      if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
        updates['phone_number'] = phoneNumber.trim();
      }
      if (address != null && address.trim().isNotEmpty) {
        updates['address'] = address.trim();
      }
      if (imageProfile != null) {
        updates['image_profile'] = imageProfile;
      }

      if (updates.isEmpty) {
        _errorMessage = 'No valid updates provided';
        return false;
      }

      // Add updated_at timestamp
      updates['updated_at'] = DateTime.now().toIso8601String();

      await _client.from('User').update(updates).eq('id', currentUserId!);
      
      // Refresh user details after successful update
      await fetchUserDetails();
      
      if (kDebugMode) print('User details updated successfully');
      return true;
      
    } on PostgrestException catch (e) {
      _errorMessage = 'Database error during update: ${e.message}';
      if (kDebugMode) print('PostgrestException during update: ${e.message}');
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update user: ${e.toString()}';
      if (kDebugMode) print('Update user error: $e');
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<bool> isProfileComplete() async {
    // Fetch latest data if not already loaded
    if (_fullName == null && !_isLoading) {
      await fetchUserDetails();
    }
    
    return _fullName != null &&
        _fullName!.trim().isNotEmpty &&
        _phoneNumber != null &&
        _phoneNumber!.trim().isNotEmpty &&
        _address != null &&
        _address!.trim().isNotEmpty;
  }

  // Validate phone number (Moroccan format)
  bool isValidPhoneNumber(String phoneNumber) {
    final cleanPhone = phoneNumber.trim();
    return cleanPhone.startsWith('06') && 
           cleanPhone.length == 10 && 
           RegExp(r'^\d+$').hasMatch(cleanPhone);
  }

  // Reset user data (useful for logout)
  void resetUserData() {
    _fullName = null;
    _email = null;
    _phoneNumber = null;
    _address = null;
    _imageProfile = null;
    _role = null;
    _isLoading = false;
    _isUpdating = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Check if user has a specific role
  bool hasRole(String role) {
    return _role?.toLowerCase() == role.toLowerCase();
  }

  // Get user initials for avatar fallback
  String getUserInitials() {
    if (_fullName == null || _fullName!.isEmpty) return 'U';
    final names = _fullName!.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return _fullName![0].toUpperCase();
  }
}