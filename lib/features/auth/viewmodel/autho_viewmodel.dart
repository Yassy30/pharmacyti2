// lib/features/auth/viewmodel/auth_viewmodel.dart
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
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    try {
      await _supabase.from('User').update({'role': role}).eq('id', user.id);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update role';
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }
}