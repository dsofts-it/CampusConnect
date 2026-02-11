import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/services/api_service.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('🔄 Loading profile data...');
    return FutureBuilder<Map<String, dynamic>>(
      future: ApiService.getProfile(),
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
          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              backgroundColor: Colors.deepPurple,
              automaticallyImplyLeading: false,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    "Error loading profile",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${snapshot.error}",
                    style: GoogleFonts.poppins(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
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

