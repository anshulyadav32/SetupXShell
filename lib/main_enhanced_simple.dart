import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'services/mock_auth_service.dart';
import 'widgets/enhanced_login_screen.dart';
import 'widgets/enhanced_home_screen.dart';
import 'widgets/enhanced_auth_wrapper.dart';

void main() {
  runApp(const EnhancedSimpleApp());
}

class EnhancedSimpleApp extends StatelessWidget {
  const EnhancedSimpleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MockAuthService(),
      child: MaterialApp(
        title: 'Enhanced Login App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const EnhancedAuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
