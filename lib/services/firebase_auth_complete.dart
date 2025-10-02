import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class FirebaseAuthComplete extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  User? _user;
  bool _isLoading = false;
  String? _verificationId;
  String? _emailOtp;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get userEmail => _user?.email;
  String? get userName => _user?.displayName ?? _user?.email?.split('@')[0];
  String? get userAvatar => _user?.photoURL;

  FirebaseAuthComplete() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Email/Password Authentication
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Email sign-in error: ${e.message}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createUserWithEmailAndPassword(String email, String password) async {
    try {
      _setLoading(true);
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Email registration error: ${e.message}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Google Sign-In
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print('Google sign-in error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Phone Number Authentication
  Future<bool> sendPhoneOtp(String phoneNumber) async {
    try {
      _setLoading(true);
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Phone verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
      return true;
    } catch (e) {
      print('Phone OTP error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyPhoneOtp(String otp) async {
    try {
      _setLoading(true);
      if (_verificationId != null) {
        final credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: otp,
        );
        await _auth.signInWithCredential(credential);
        return true;
      }
      return false;
    } catch (e) {
      print('Phone OTP verification error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Email OTP Authentication
  Future<bool> sendEmailOtp(String email) async {
    try {
      _setLoading(true);
      await _auth.sendPasswordResetEmail(email: email);
      _emailOtp = 'sent'; // In real implementation, you'd handle the OTP differently
      return true;
    } catch (e) {
      print('Email OTP error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyEmailOtp(String email, String otp) async {
    try {
      _setLoading(true);
      // For demo purposes, we'll use a simple OTP verification
      // In production, you'd implement proper email OTP verification
      if (otp == '123456') {
        // Create a temporary user or sign in
        await _auth.signInAnonymously();
        return true;
      }
      return false;
    } catch (e) {
      print('Email OTP verification error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Password Reset
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Password reset error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign Out
  Future<void> logout() async {
    try {
      _setLoading(true);
      await _auth.signOut();
      await _googleSignIn.signOut();
      _verificationId = null;
      _emailOtp = null;
    } finally {
      _setLoading(false);
    }
  }

  // Update Profile
  Future<bool> updateProfile({String? displayName, String? photoURL}) async {
    try {
      _setLoading(true);
      await _user?.updateDisplayName(displayName);
      if (photoURL != null) {
        await _user?.updatePhotoURL(photoURL);
      }
      await _user?.reload();
      _user = _auth.currentUser;
      return true;
    } catch (e) {
      print('Profile update error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete Account
  Future<bool> deleteAccount() async {
    try {
      _setLoading(true);
      await _user?.delete();
      return true;
    } catch (e) {
      print('Account deletion error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
