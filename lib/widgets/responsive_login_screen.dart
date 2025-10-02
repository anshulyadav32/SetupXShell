import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/mock_auth_service.dart';

class ResponsiveLoginScreen extends StatefulWidget {
  const ResponsiveLoginScreen({super.key});

  @override
  State<ResponsiveLoginScreen> createState() => _ResponsiveLoginScreenState();
}

class _ResponsiveLoginScreenState extends State<ResponsiveLoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  bool _obscurePassword = true;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) return;

    try {
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
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error: ${e.toString()}');
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    // Mock Google sign-in for demo purposes
    try {
      final authService = Provider.of<MockAuthService>(context, listen: false);
      await authService.signInWithEmailAndPassword(
        'google.user@example.com',
        'google123',
      );
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Google Sign-In failed: ${e.toString()}');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    
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
                  maxWidth: isMobile ? double.infinity : (isTablet ? 500 : 400),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and Title
                    _buildHeader(isMobile),
                    SizedBox(height: isMobile ? 32 : 48),
                    
                    // Login Form
                    _buildLoginForm(isMobile, isTablet),
                    
                    SizedBox(height: isMobile ? 24 : 32),
                    
                    // Google Sign In Button
                    _buildGoogleSignInButton(isMobile),
                    
                    SizedBox(height: isMobile ? 24 : 32),
                    
                    // Toggle Button
                    _buildToggleButton(),
                  ],
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
        Container(
          width: isMobile ? 60 : 80,
          height: isMobile ? 60 : 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isMobile ? 15 : 20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.lock_outline,
            size: isMobile ? 30 : 40,
            color: const Color(0xFF6366F1),
          ),
        ).animate().scale(duration: 600.ms).fadeIn(),
        
        SizedBox(height: isMobile ? 16 : 24),
        
        Text(
          'Welcome Back!',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().slideY(duration: 600.ms, begin: 0.3).fadeIn(),
        
        const SizedBox(height: 8),
        
        Text(
          'Sign in to your account',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 14 : 16,
            color: Colors.white.withOpacity(0.8),
          ),
        ).animate().slideY(duration: 600.ms, begin: 0.3, delay: 200.ms).fadeIn(),
      ],
    );
  }

  Widget _buildLoginForm(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 15 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Email Field
            _buildEmailField(isMobile),
            SizedBox(height: isMobile ? 16 : 20),
            
            // Password Field
            _buildPasswordField(isMobile),
            SizedBox(height: isMobile ? 24 : 32),
            
            // Login Button
            _buildLoginButton(isMobile),
          ],
        ),
      ),
    ).animate().slideY(duration: 600.ms, begin: 0.3, delay: 400.ms).fadeIn();
  }

  Widget _buildEmailField(bool isMobile) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.poppins(fontSize: isMobile ? 14 : 16),
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(bool isMobile) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: GoogleFonts.poppins(fontSize: isMobile ? 14 : 16),
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(bool isMobile) {
    return Consumer<MockAuthService>(
      builder: (context, authService, child) {
        return SizedBox(
          width: double.infinity,
          height: isMobile ? 48 : 56,
          child: ElevatedButton(
            onPressed: authService.isLoading ? null : _authenticate,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              ),
              elevation: 0,
            ),
            child: authService.isLoading
                ? SizedBox(
                    width: isMobile ? 20 : 24,
                    height: isMobile ? 20 : 24,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    _isLogin ? 'Sign In' : 'Create Account',
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

  Widget _buildGoogleSignInButton(bool isMobile) {
    return Consumer<MockAuthService>(
      builder: (context, authService, child) {
        return SizedBox(
          width: double.infinity,
          height: isMobile ? 48 : 56,
          child: OutlinedButton.icon(
            onPressed: authService.isLoading ? null : _signInWithGoogle,
            icon: Image.asset(
              'assets/google_logo.png',
              width: isMobile ? 20 : 24,
              height: isMobile ? 20 : 24,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.g_mobiledata, size: 24);
              },
            ),
            label: Text(
              'Continue with Google',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
              ),
              elevation: 0,
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
      },
      child: Text(
        _isLogin ? 'Don\'t have an account? Sign Up' : 'Already have an account? Sign In',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 16,
        ),
      ),
    ).animate().slideY(duration: 600.ms, begin: 0.3, delay: 600.ms).fadeIn();
  }
}
