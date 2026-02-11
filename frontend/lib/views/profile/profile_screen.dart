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
        
        print('✅ Profile loaded successfully: $name ($role)');

        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            backgroundColor: Colors.deepPurple,
            automaticallyImplyLeading: false, // Don't show back button
          ),
          body: SingleChildScrollView( // Added scroll view for safety on small screens
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple.shade100,
                  child: Text(
                    initial,
                    style: TextStyle(fontSize: 40, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  role.toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 32),
                ListTile(
                  leading: Icon(Icons.email, color: Colors.deepPurple),
                  title: Text(email, style: GoogleFonts.poppins()),
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Logout', style: GoogleFonts.poppins(color: Colors.red)),
                  onTap: () async {
                    await ApiService.removeToken();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

