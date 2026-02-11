import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/services/api_service.dart';

class ProfileScreen extends StatelessWidget {
  Future<Map<String, dynamic>> _loadProfile() async {
    // First, test the token
    await ApiService.testToken();
    
    // Then load profile
    return await ApiService.getProfile();
  }
  
  @override
  Widget build(BuildContext context) {
    print('🔄 Loading profile data...');
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('⏳ Waiting for profile data...');
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              backgroundColor: Colors.deepPurple,
              automaticallyImplyLeading: false,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          print('❌ Profile error: ${snapshot.error}');
          
          // Check if it's a token/auth error
          final errorMsg = snapshot.error.toString();
          final isAuthError = errorMsg.contains('401') || 
                             errorMsg.contains('token') || 
                             errorMsg.contains('No token');
          
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              backgroundColor: Colors.deepPurple,
              automaticallyImplyLeading: false,
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isAuthError ? Icons.lock_outline : Icons.error_outline,
                      size: 64,
                      color: isAuthError ? Colors.orange : Colors.red,
                    ),
                    SizedBox(height: 16),
                    Text(
                      isAuthError ? "Please Login" : "Error loading profile",
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      isAuthError 
                          ? "You need to login to view your profile"
                          : "Something went wrong: ${snapshot.error}",
                      style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    if (isAuthError)
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        icon: Icon(Icons.login),
                        label: Text('Go to Login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
           return Center(child: Text("No user data found"));
        }

        final user = snapshot.data!['data']; 
        
        if (user == null) {
           return Center(child: Text("User data is empty"));
        }
        
        final name = user['name'] ?? 'User';
        final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
        final email = user['email'] ?? 'No Email';
        final role = user['role'] ?? 'Student';
        final userId = user['_id'] ?? 'Unknown ID';
        
        print('✅ Profile loaded successfully: $name ($role)');

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: Text('Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            backgroundColor: Colors.deepPurple,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header Section with Profile Picture
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 40),
                  child: Column(
                    children: [
                      // Profile Picture
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: Text(
                            initial,
                            style: TextStyle(
                              fontSize: 48,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Name
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      // Role Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: role == 'teacher' ? Colors.amber : Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          role.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Profile Details Section
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Information',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Email Card
                      _buildInfoCard(
                        icon: Icons.email_outlined,
                        iconColor: Colors.blue,
                        title: 'Email',
                        value: email,
                      ),
                      SizedBox(height: 12),
                      
                      // Role Card
                      _buildInfoCard(
                        icon: Icons.work_outline,
                        iconColor: Colors.purple,
                        title: 'Role',
                        value: role == 'teacher' ? 'Teacher' : 'Student',
                      ),
                      SizedBox(height: 12),
                      
                      // User ID Card
                      _buildInfoCard(
                        icon: Icons.fingerprint,
                        iconColor: Colors.green,
                        title: 'User ID',
                        value: userId,
                        isMonospace: true,
                      ),
                      
                      SizedBox(height: 32),
                      
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await ApiService.removeToken();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          icon: Icon(Icons.logout, color: Colors.white),
                          label: Text(
                            'Logout',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    bool isMonospace = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: isMonospace ? 2 : 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

