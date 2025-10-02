import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';

class Auth0Service extends ChangeNotifier {
  late Auth0 _auth0;
  Credentials? _credentials;
  UserProfile? _userProfile;
  bool _isLoading = false;

  Auth0Service() {
    _auth0 = Auth0('YOUR_AUTH0_DOMAIN', 'YOUR_AUTH0_CLIENT_ID');
  }

  bool get isLoggedIn => _credentials != null;
  bool get isLoading => _isLoading;
  UserProfile? get userProfile => _userProfile;
  String? get accessToken => _credentials?.accessToken;

  Future<void> loginWithGoogle() async {
    try {
      _setLoading(true);
      
      final credentials = await _auth0.webAuthentication().login();
      
      if (credentials != null) {
        _credentials = credentials;
        _userProfile = await _auth0.userProfile();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Auth0 login error: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      _setLoading(true);
      await _auth0.webAuthentication().logout();
      _credentials = null;
      _userProfile = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Auth0 logout error: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
