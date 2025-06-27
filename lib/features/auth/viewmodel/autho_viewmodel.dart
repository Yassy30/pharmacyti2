// lib/features/auth/viewmodel/auth_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true; 
      _errorMessage = null;
      notifyListeners();

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return true;
      } else {
        _errorMessage = 'Invalid credentials';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String fullName, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _supabase.from('User').insert({
          'id': response.user!.id,
          'email': email,
          'full_name': fullName,
          'role': 'client', // Default role, updated in WhoAreYou
        });
        return true;
      } else {
        _errorMessage = 'Signup failed';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> getUserRole() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final userData = await _supabase
          .from('User')
          .select('role')
          .eq('id', user.id)
          .single();
      return userData['role'] as String?;
    } catch (e) {
      _errorMessage = 'Failed to fetch user role';
      notifyListeners();
      return null;
    }
  }

Future<bool> updateUserRole(String role) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        _errorMessage = 'No authenticated user found. Please log in again.';
        if (kDebugMode) print('Update role error: No user ID');
        return false;
      }

      // Validate role against ENUM values
      if (!['client', 'pharmacy', 'livreur'].contains(role)) {
        _errorMessage = 'Invalid role: $role';
        if (kDebugMode) print('Update role error: Invalid role');
        return false;
      }

      final response = await _supabase
          .from('User')
          .update({'role': role})
          .eq('id', userId)
          .select('role')
          .single();

      if (response['role'] != role) {
        _errorMessage = 'Failed to update role in database';
        if (kDebugMode) print('Update role error: Role not updated');
        return false;
      }

      if (kDebugMode) print('Role updated successfully: $role');
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update role: $e';
      if (kDebugMode) print('Update role error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }
} 