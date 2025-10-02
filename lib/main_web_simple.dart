import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'services/mock_auth_service.dart';
import 'widgets/responsive_home_screen_fixed.dart';

void main() {
  runApp(const WebSimpleApp());
}

class WebSimpleApp extends StatelessWidget {
  const WebSimpleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MockAuthService(),
      child: MaterialApp(
        title: 'SetupX Web App',
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
        home: const WebSimpleWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class WebSimpleWrapper extends StatelessWidget {
  const WebSimpleWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MockAuthService>(
      builder: (context, authService, child) {
        if (authService.isLoggedIn) {
          return const ResponsiveHomeScreenFixed();
        } else {
          return const WebSimpleAuthScreen();
        }
      },
    );
  }
}

class WebSimpleAuthScreen extends StatefulWidget {
  const WebSimpleAuthScreen({super.key});

  @override
  State<WebSimpleAuthScreen> createState() => _WebSimpleAuthScreenState();
}

class _WebSimpleAuthScreenState extends State<WebSimpleAuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFEC4899),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? double.infinity : 400,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 24 : 32),
                    child: Column(
                      children: [
                        _buildHeader(isMobile),
                        SizedBox(height: isMobile ? 24 : 32),
                        _buildToggleButtons(isMobile),
                        SizedBox(height: isMobile ? 24 : 32),
                        _buildEmailField(isMobile),
                        SizedBox(height: isMobile ? 16 : 20),
                        _buildPasswordField(isMobile),
                        SizedBox(height: isMobile ? 24 : 32),
                        _buildAuthButton(isMobile),
                        SizedBox(height: isMobile ? 16 : 20),
                        _buildGoogleButton(isMobile),
                        SizedBox(height: isMobile ? 16 : 20),
                        _buildPhoneButton(isMobile),
                        SizedBox(height: isMobile ? 16 : 20),
                        _buildForgotPasswordButton(isMobile),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      children: [
        Icon(
          Icons.security,
          size: isMobile ? 48 : 64,
          color: const Color(0xFF6366F1),
        ),
        SizedBox(height: isMobile ? 16 : 20),
        Text(
          'SetupX Authentication',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: isMobile ? 8 : 12),
        Text(
          'Secure authentication system',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 14 : 16,
            color: const Color(0xFF6B7280),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildToggleButtons(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isLogin = true),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 12 : 16,
                  horizontal: isMobile ? 16 : 20,
                ),
                decoration: BoxDecoration(
                  color: _isLogin ? const Color(0xFF6366F1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                ),
                child: Text(
                  'Sign In',
                  style: GoogleFonts.poppins(
                    color: _isLogin ? Colors.white : const Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                    fontSize: isMobile ? 14 : 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isLogin = false),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 12 : 16,
                  horizontal: isMobile ? 16 : 20,
                ),
                decoration: BoxDecoration(
                  color: !_isLogin ? const Color(0xFF6366F1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
                ),
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.poppins(
                    color: !_isLogin ? Colors.white : const Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                    fontSize: isMobile ? 14 : 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(duration: 600.ms, begin: 0.3, delay: 200.ms);
  }

  Widget _buildEmailField(bool isMobile) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        ),
      ),
    );
  }

  Widget _buildPasswordField(bool isMobile) {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        ),
      ),
    );
  }

  Widget _buildAuthButton(bool isMobile) {
    return Consumer<MockAuthService>(
      builder: (context, authService, child) {
        return SizedBox(
          width: double.infinity,
          height: isMobile ? 48 : 56,
          child: ElevatedButton(
            onPressed: authService.isLoading ? null : _handleAuth,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
              ),
            ),
            child: authService.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    _isLogin ? 'Sign In' : 'Sign Up',
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildGoogleButton(bool isMobile) {
    return Consumer<MockAuthService>(
      builder: (context, authService, child) {
        return SizedBox(
          width: double.infinity,
          height: isMobile ? 48 : 56,
          child: OutlinedButton.icon(
            onPressed: authService.isLoading ? null : _handleGoogleSignIn,
            icon: authService.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.g_mobiledata, color: Color(0xFF4285F4)),
            label: Text(
              'Continue with Google',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4285F4),
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF4285F4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneButton(bool isMobile) {
    return Consumer<MockAuthService>(
      builder: (context, authService, child) {
        return SizedBox(
          width: double.infinity,
          height: isMobile ? 48 : 56,
          child: OutlinedButton.icon(
            onPressed: authService.isLoading ? null : _handlePhoneAuth,
            icon: authService.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.phone, color: Color(0xFF10B981)),
            label: Text(
              'Continue with Phone',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF10B981),
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF10B981)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForgotPasswordButton(bool isMobile) {
    return TextButton(
      onPressed: _handleForgotPassword,
      child: Text(
        'Forgot Password?',
        style: GoogleFonts.poppins(
          color: const Color(0xFF6366F1),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _handleAuth() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackBar('Please fill in all fields');
      return;
    }

    final authService = Provider.of<MockAuthService>(context, listen: false);
    bool success;

    if (_isLogin) {
      success = await authService.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    } else {
      success = await authService.createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    }

    if (!success && mounted) {
      _showErrorSnackBar('Authentication failed. Please try again.');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authService = Provider.of<MockAuthService>(context, listen: false);
    
    // Simulate Google sign-in
    await Future.delayed(const Duration(seconds: 2));
    
    await authService.signInWithEmailAndPassword(
      'user@gmail.com',
      'password123',
    );
  }

  Future<void> _handlePhoneAuth() async {
    final authService = Provider.of<MockAuthService>(context, listen: false);
    
    // Simulate phone authentication
    await Future.delayed(const Duration(seconds: 2));
    
    await authService.signInWithEmailAndPassword(
      'user@phone.com',
      'password123',
    );
  }

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('Please enter your email address first');
      return;
    }

    // Simulate password reset
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      _showSuccessSnackBar('Password reset email sent');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }
}
