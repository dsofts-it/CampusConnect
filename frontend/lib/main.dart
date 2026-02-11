
import 'package:flutter/material.dart';
import 'package:frontend/views/auth/signup_screen.dart';
import 'package:frontend/views/auth/login_screen.dart';
import 'package:frontend/views/main_screen.dart';
import 'package:frontend/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure we can check the token before running the app
  String? token = await ApiService.getToken();
  runApp(CampusConnectApp(isLoggedIn: token != null));
}

class CampusConnectApp extends StatelessWidget {
  final bool isLoggedIn;

  const CampusConnectApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusConnect',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: isLoggedIn ? '/main' : '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/main': (context) => MainScreen(),
        // Dashboard is now part of MainScreen
      },
    );
  }
}
