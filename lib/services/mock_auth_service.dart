import 'package:flutter/material.dart';

class MockAuthService extends ChangeNotifier {
  String? _userEmail;
  String? _userName;
  String? _userAvatar;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get userAvatar => _userAvatar;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock authentication - accept any email/password
    if (email.isNotEmpty && password.isNotEmpty) {
      _userEmail = email;
      _userName = email.split('@')[0];
      _userAvatar = 'https://ui-avatars.com/api/?name=${_userName}&background=6366F1&color=fff';
      _isLoggedIn = true;
      notifyListeners();
      _setLoading(false);
      return true;
    }
    _setLoading(false);
    return false;
  }

  Future<bool> createUserWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock registration - accept any email/password
    if (email.isNotEmpty && password.isNotEmpty) {
      _userEmail = email;
      _userName = email.split('@')[0];
      _userAvatar = 'https://ui-avatars.com/api/?name=${_userName}&background=6366F1&color=fff';
      _isLoggedIn = true;
      notifyListeners();
      _setLoading(false);
      return true;
    }
    _setLoading(false);
    return false;
  }

  Future<void> logout() async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 500));
    _userEmail = null;
    _userName = null;
    _userAvatar = null;
    _isLoggedIn = false;
    notifyListeners();
    _setLoading(false);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
