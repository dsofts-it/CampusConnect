import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/views/dashboard/dashboard_screen.dart';
import 'package:frontend/views/profile/profile_screen.dart';
import 'package:frontend/views/upload/upload_screen.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/views/explore/explore_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String? _userRole;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    final role = await ApiService.getUserRole();
    print('🔑 User role: $role');
    
    if (mounted) {
      setState(() {
        _userRole = role;
        _isLoading = false;
      });
    }
  }

  void _onTabTapped(int index) {
    // If student tries to tap Upload (index 2), ignore or show message
    if (_userRole != 'teacher' && index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only teachers can upload content')),
      );
      return;
    }
    
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool isTeacher = _userRole == 'teacher';
    
    // Always show 4 pages - use placeholder for students' upload
    final List<Widget> displayPages = [
      DashboardScreen(),
      ExploreScreen(),
      isTeacher ? UploadScreen() : Center(child: Text('Only teachers can upload')),
      ProfileScreen(),
    ];
    
    // Define tabs - always show all 4
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Explore',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_circle_outline),
        label: 'Upload',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: displayPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: items,
      ),
    );
  }
}
