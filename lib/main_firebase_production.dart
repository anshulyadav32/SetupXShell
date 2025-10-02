import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:country_picker/country_picker.dart';
import 'firebase_options.dart';
import 'services/firebase_auth_complete.dart';
import 'widgets/responsive_home_screen_fixed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FirebaseProductionApp());
}

class FirebaseProductionApp extends StatelessWidget {
  const FirebaseProductionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FirebaseAuthComplete(),
      child: MaterialApp(
        title: 'SetupX Authentication',
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
        home: const FirebaseProductionWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class FirebaseProductionWrapper extends StatelessWidget {
  const FirebaseProductionWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseAuthComplete>(
      builder: (context, authService, child) {
        if (authService.isLoggedIn) {
          return const ResponsiveHomeScreenFixed();
        } else {
          return const FirebaseProductionAuthScreen();
        }
      },
    );
  }
}

class FirebaseProductionAuthScreen extends StatefulWidget {
  const FirebaseProductionAuthScreen({super.key});

  @override
  State<FirebaseProductionAuthScreen> createState() => _FirebaseProductionAuthScreenState();
}

class _FirebaseProductionAuthScreenState extends State<FirebaseProductionAuthScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  
  late TabController _tabController;
  bool _isLogin = true;
  String _selectedCountryCode = '+1';
  bool _isOtpSent = false;
  bool _isEmailOtpSent = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
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
                  maxWidth: isMobile ? double.infinity : 500,
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
                  child: Column(
                    children: [
                      _buildHeader(isMobile),
                      _buildTabBar(isMobile),
                      SizedBox(
                        height: isMobile ? 400 : 500,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildEmailAuth(isMobile),
                            _buildPhoneAuth(isMobile),
                            _buildEmailOtpAuth(isMobile),
                            _buildGoogleAuth(isMobile),
                          ],
                        ),
                      ),
                    ],
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
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      child: Column(
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
            'Secure authentication with Firebase',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 14 : 16,
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildTabBar(bool isMobile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF6366F1),
          borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF6B7280),
        labelStyle: GoogleFonts.poppins(
          fontSize: isMobile ? 12 : 14,
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(
            icon: Icon(Icons.email, size: isMobile ? 16 : 18),
            text: 'Email',
          ),
          Tab(
            icon: Icon(Icons.phone, size: isMobile ? 16 : 18),
            text: 'Phone',
          ),
          Tab(
            icon: Icon(Icons.mark_email_unread, size: isMobile ? 16 : 18),
            text: 'Email OTP',
          ),
          Tab(
            icon: Icon(Icons.g_mobiledata, size: isMobile ? 16 : 18),
            text: 'Google',
          ),
        ],
      ),
    ).animate().slideY(duration: 600.ms, begin: 0.3, delay: 200.ms);
  }

  Widget _buildEmailAuth(bool isMobile) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildToggleButtons(isMobile),
            SizedBox(height: isMobile ? 24 : 32),
            _buildEmailField(isMobile),
            SizedBox(height: isMobile ? 16 : 20),
            _buildPasswordField(isMobile),
            SizedBox(height: isMobile ? 24 : 32),
            _buildEmailAuthButton(isMobile),
            SizedBox(height: isMobile ? 16 : 20),
            _buildForgotPasswordButton(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneAuth(bool isMobile) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      child: Column(
        children: [
          _buildPhoneField(isMobile),
          SizedBox(height: isMobile ? 24 : 32),
          if (_isOtpSent) ...[
            _buildOtpField(isMobile),
            SizedBox(height: isMobile ? 24 : 32),
            _buildVerifyOtpButton(isMobile),
          ] else
            _buildSendOtpButton(isMobile),
        ],
      ),
    );
  }

  Widget _buildEmailOtpAuth(bool isMobile) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      child: Column(
        children: [
          _buildEmailField(isMobile),
          SizedBox(height: isMobile ? 24 : 32),
          if (_isEmailOtpSent) ...[
            _buildOtpField(isMobile),
            SizedBox(height: isMobile ? 24 : 32),
            _buildVerifyEmailOtpButton(isMobile),
          ] else
            _buildSendEmailOtpButton(isMobile),
        ],
      ),
    );
  }

  Widget _buildGoogleAuth(bool isMobile) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      child: Column(
        children: [
          Icon(
            Icons.g_mobiledata,
            size: isMobile ? 64 : 80,
            color: const Color(0xFF4285F4),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          Text(
            'Sign in with Google',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            'Quick and secure authentication',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 14 : 16,
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 32 : 40),
          _buildGoogleSignInButton(isMobile),
        ],
      ),
    );
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
    );
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
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
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

  Widget _buildPhoneField(bool isMobile) {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        prefixIcon: const Icon(Icons.phone_outlined),
        prefix: GestureDetector(
          onTap: () => _showCountryPicker(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              _selectedCountryCode,
              style: GoogleFonts.poppins(
                color: const Color(0xFF6366F1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        ),
      ),
    );
  }

  Widget _buildOtpField(bool isMobile) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      controller: _otpController,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        fieldHeight: isMobile ? 48 : 56,
        fieldWidth: isMobile ? 40 : 48,
        activeFillColor: Colors.white,
        inactiveFillColor: const Color(0xFFF3F4F6),
        selectedFillColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
        activeColor: const Color(0xFF6366F1),
        inactiveColor: const Color(0xFFD1D5DB),
        selectedColor: const Color(0xFF6366F1),
      ),
      enableActiveFill: true,
      keyboardType: TextInputType.number,
      onCompleted: (value) {
        // Auto-verify when OTP is complete
      },
    );
  }

  Widget _buildEmailAuthButton(bool isMobile) {
    return Consumer<FirebaseAuthComplete>(
      builder: (context, authService, child) {
        return SizedBox(
          width: double.infinity,
          height: isMobile ? 48 : 56,
          child: ElevatedButton(
            onPressed: authService.isLoading ? null : _handleEmailAuth,
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

  Widget _buildSendOtpButton(bool isMobile) {
    return Consumer<FirebaseAuthComplete>(
      builder: (context, authService, child) {
        return SizedBox(
          width: double.infinity,
          height: isMobile ? 48 : 56,
          child: ElevatedButton(
            onPressed: authService.isLoading ? null : _sendPhoneOtp,
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
                    'Send OTP',
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

  Widget _buildVerifyOtpButton(bool isMobile) {
    return Consumer<FirebaseAuthComplete>(
      builder: (context, authService, child) {
        return SizedBox(
          width: double.infinity,
          height: isMobile ? 48 : 56,
          child: ElevatedButton(
            onPressed: authService.isLoading ? null : _verifyPhoneOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
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
                    'Verify OTP',
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

  Widget _buildSendEmailOtpButton(bool isMobile) {
    return Consumer<FirebaseAuthComplete>(
      builder: (context, authService, child) {
        return SizedBox(
          width: double.infinity,
          height: isMobile ? 48 : 56,
          child: ElevatedButton(
            onPressed: authService.isLoading ? null : _sendEmailOtp,
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
                    'Send Email OTP',
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

  Widget _buildVerifyEmailOtpButton(bool isMobile) {
    return Consumer<FirebaseAuthComplete>(
      builder: (context, authService, child) {
        return SizedBox(
          width: double.infinity,
          height: isMobile ? 48 : 56,
          child: ElevatedButton(
            onPressed: authService.isLoading ? null : _verifyEmailOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
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
                    'Verify Email OTP',
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
    return Consumer<FirebaseAuthComplete>(
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

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      onSelect: (country) {
        setState(() {
          _selectedCountryCode = '+${country.phoneCode}';
        });
      },
    );
  }

  Future<void> _handleEmailAuth() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = Provider.of<FirebaseAuthComplete>(context, listen: false);
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

  Future<void> _sendPhoneOtp() async {
    if (_phoneController.text.isEmpty) {
      _showErrorSnackBar('Please enter your phone number');
      return;
    }

    final authService = Provider.of<FirebaseAuthComplete>(context, listen: false);
    final phoneNumber = '$_selectedCountryCode${_phoneController.text}';
    
    final success = await authService.sendPhoneOtp(phoneNumber);
    if (success && mounted) {
      setState(() => _isOtpSent = true);
      _showSuccessSnackBar('OTP sent to your phone number');
    } else if (mounted) {
      _showErrorSnackBar('Failed to send OTP. Please try again.');
    }
  }

  Future<void> _verifyPhoneOtp() async {
    if (_otpController.text.length != 6) {
      _showErrorSnackBar('Please enter a valid 6-digit OTP');
      return;
    }

    final authService = Provider.of<FirebaseAuthComplete>(context, listen: false);
    final success = await authService.verifyPhoneOtp(_otpController.text);
    
    if (!success && mounted) {
      _showErrorSnackBar('Invalid OTP. Please try again.');
    }
  }

  Future<void> _sendEmailOtp() async {
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('Please enter your email address');
      return;
    }

    final authService = Provider.of<FirebaseAuthComplete>(context, listen: false);
    final success = await authService.sendEmailOtp(_emailController.text);
    
    if (success && mounted) {
      setState(() => _isEmailOtpSent = true);
      _showSuccessSnackBar('OTP sent to your email address');
    } else if (mounted) {
      _showErrorSnackBar('Failed to send OTP. Please try again.');
    }
  }

  Future<void> _verifyEmailOtp() async {
    if (_otpController.text.length != 6) {
      _showErrorSnackBar('Please enter a valid 6-digit OTP');
      return;
    }

    final authService = Provider.of<FirebaseAuthComplete>(context, listen: false);
    final success = await authService.verifyEmailOtp(
      _emailController.text,
      _otpController.text,
    );
    
    if (!success && mounted) {
      _showErrorSnackBar('Invalid OTP. Please try again.');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authService = Provider.of<FirebaseAuthComplete>(context, listen: false);
    final success = await authService.signInWithGoogle();
    
    if (!success && mounted) {
      _showErrorSnackBar('Google sign-in failed. Please try again.');
    }
  }

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('Please enter your email address first');
      return;
    }

    final authService = Provider.of<FirebaseAuthComplete>(context, listen: false);
    final success = await authService.resetPassword(_emailController.text);
    
    if (success && mounted) {
      _showSuccessSnackBar('Password reset email sent');
    } else if (mounted) {
      _showErrorSnackBar('Failed to send reset email. Please try again.');
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
