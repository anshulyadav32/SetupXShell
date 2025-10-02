import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_auth_service.dart';
import 'responsive_login_screen.dart';
import 'responsive_home_screen_fixed.dart';

class ResponsiveAuthWrapper extends StatelessWidget {
  const ResponsiveAuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MockAuthService>(
      builder: (context, authService, child) {
        if (authService.isLoggedIn) {
          return const ResponsiveHomeScreenFixed();
        } else {
          return const ResponsiveLoginScreen();
        }
      },
    );
  }
}
