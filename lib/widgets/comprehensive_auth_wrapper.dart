import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_auth_complete.dart';
import 'comprehensive_auth_screen.dart';
import 'responsive_home_screen_fixed.dart';

class ComprehensiveAuthWrapper extends StatelessWidget {
  const ComprehensiveAuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthComplete>(
      builder: (context, authService, child) {
        if (authService.isLoggedIn) {
          return const ResponsiveHomeScreenFixed();
        } else {
          return const ComprehensiveAuthScreen();
        }
      },
    );
  }
}
