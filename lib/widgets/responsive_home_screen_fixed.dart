import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/firebase_auth_complete.dart';

class ResponsiveHomeScreenFixed extends StatelessWidget {
  const ResponsiveHomeScreenFixed({super.key});

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
          child: Consumer<FirebaseAuthComplete>(
            builder: (context, authService, child) {
              return Column(
                children: [
                  // Header
                  _buildHeader(context, authService, isMobile),
                  
                  // Content - Now scrollable
                  Expanded(
                    child: _buildContent(context, authService, isMobile, isTablet),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FirebaseAuthComplete authService, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: isMobile ? 40 : 50,
            height: isMobile ? 40 : 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isMobile ? 20 : 25),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isMobile ? 20 : 25),
              child: authService.userAvatar != null
                  ? Image.network(
                      authService.userAvatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          color: Colors.white,
                          size: isMobile ? 20 : 30,
                        );
                      },
                    )
                  : Icon(
                      Icons.person,
                      color: Colors.white,
                      size: isMobile ? 20 : 30,
                    ),
            ),
          ),
          
          SizedBox(width: isMobile ? 12 : 16),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
                Text(
                  authService.userName ?? 'User',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Profile Button
          IconButton(
            onPressed: () => _showProfileDialog(context, authService, isMobile),
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
              size: isMobile ? 20 : 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, FirebaseAuthComplete authService, bool isMobile, bool isTablet) {
    return Container(
      margin: EdgeInsets.all(isMobile ? 16 : 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Success Card
            _buildSuccessCard(isMobile),
            
            SizedBox(height: isMobile ? 16 : 24),
            
            // User Info Card
            _buildUserInfoCard(authService, isMobile),
            
            SizedBox(height: isMobile ? 16 : 24),
            
            // Action Buttons
            _buildActionButtons(context, authService, isMobile),
            
            // Add bottom padding for better scrolling
            SizedBox(height: isMobile ? 20 : 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessCard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: isMobile ? 8 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isMobile ? 50 : 64,
            height: isMobile ? 50 : 64,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(isMobile ? 25 : 32),
            ),
            child: Icon(
              Icons.check_circle,
              size: isMobile ? 25 : 32,
              color: Colors.green,
            ),
          ),
          
          SizedBox(height: isMobile ? 12 : 16),
          
          Text(
            'Successfully Logged In!',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: isMobile ? 4 : 6),
          
          Text(
            'You are now authenticated and ready to use the app.',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 13 : 15,
              color: const Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().scale(duration: 600.ms).fadeIn();
  }

  Widget _buildUserInfoCard(FirebaseAuthComplete authService, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: isMobile ? 8 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: const Color(0xFF6366F1),
                size: isMobile ? 20 : 24,
              ),
              SizedBox(width: isMobile ? 8 : 12),
              Text(
                'User Information',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          
          SizedBox(height: isMobile ? 12 : 16),
          
          _buildInfoRow(
            Icons.person, 
            'Name', 
            authService.userName ?? 'Unknown',
            isMobile,
          ),
          SizedBox(height: isMobile ? 8 : 12),
          _buildInfoRow(
            Icons.email, 
            'Email', 
            authService.userEmail ?? 'Unknown',
            isMobile,
          ),
          SizedBox(height: isMobile ? 8 : 12),
          _buildInfoRow(
            Icons.verified, 
            'Status', 
            'Verified',
            isMobile,
          ),
        ],
      ),
    ).animate().slideX(duration: 600.ms, begin: 0.3, delay: 200.ms).fadeIn();
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isMobile) {
    return Row(
      children: [
        Icon(
          icon,
          size: isMobile ? 16 : 18,
          color: const Color(0xFF6B7280),
        ),
        SizedBox(width: isMobile ? 8 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 12 : 14,
                  color: const Color(0xFF6B7280),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, FirebaseAuthComplete authService, bool isMobile) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: isMobile ? 48 : 56,
          child: ElevatedButton.icon(
            onPressed: () => _showProfileDialog(context, authService, isMobile),
            icon: Icon(
              Icons.person,
              size: isMobile ? 18 : 20,
            ),
            label: Text(
              'View Profile',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
              ),
              elevation: 2,
            ),
          ),
        ),
        
        SizedBox(height: isMobile ? 12 : 16),
        
        SizedBox(
          width: double.infinity,
          height: isMobile ? 48 : 56,
          child: OutlinedButton.icon(
            onPressed: () => _showLogoutDialog(context, authService),
            icon: Icon(
              Icons.logout,
              size: isMobile ? 18 : 20,
            ),
            label: Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
              side: const BorderSide(color: Color(0xFFEF4444)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
              ),
            ),
          ),
        ),
      ],
    ).animate().slideY(duration: 600.ms, begin: 0.3, delay: 400.ms).fadeIn();
  }

  void _showProfileDialog(BuildContext context, FirebaseAuthComplete authService, bool isMobile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 12 : 16)),
        title: Text(
          'User Profile',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogInfoRow('Name', authService.userName ?? 'Unknown', isMobile),
            _buildDialogInfoRow('Email', authService.userEmail ?? 'Unknown', isMobile),
            _buildDialogInfoRow('Status', 'Verified', isMobile),
            _buildDialogInfoRow('Provider', 'Mock Authentication', isMobile),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(
                color: const Color(0xFF6366F1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogInfoRow(String label, String value, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 4 : 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isMobile ? 60 : 80,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 13 : 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 13 : 14,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, FirebaseAuthComplete authService) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isMobile ? 12 : 16)),
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 14 : 16,
            color: const Color(0xFF6B7280),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              authService.logout();
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(
                color: const Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
