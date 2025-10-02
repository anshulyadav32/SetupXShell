import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_auth_service.dart';
import 'enhanced_login_screen.dart';
import 'enhanced_home_screen.dart';

class EnhancedAuthWrapper extends StatelessWidget {
  const EnhancedAuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MockAuthService>(
      builder: (context, authService, child) {
        if (authService.isLoggedIn) {
          return const EnhancedHomeScreen();
        } else {
          return const EnhancedLoginScreen();
        }
      },
    );
  }
}
