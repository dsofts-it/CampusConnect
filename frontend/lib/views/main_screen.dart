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

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    final role = await ApiService.getUserRole();
    if (role == null) {
       // Handle logout or redirect?
    }
    
    setState(() {
      _userRole = role;
      _isLoading = false;
      
      _pages = [
        DashboardScreen(),
        ExploreScreen(), // We will create this
      ];

      if (_userRole == 'teacher') {
        _pages.add(UploadScreen());
      }

      _pages.add(ProfileScreen());
    });
  }

  void _onTabTapped(int index) {
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
    
    // Define tabs dynamically
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
        children: _pages,
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
