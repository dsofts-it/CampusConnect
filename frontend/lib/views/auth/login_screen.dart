import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/widgets/custom_textfield.dart';
import 'package:frontend/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('🔐 Attempting login...');
      print('📧 Email: ${_emailController.text}');
      
      final response = await ApiService.login(
        _emailController.text,
        _passwordController.text,
      );

      print('✅ Login response received:');
      print('   Full response: $response');
      print('   Response type: ${response.runtimeType}');
      print('   Response keys: ${response.keys}');
      
      // Extract token - try different possible locations
      String? token;
      String? role;
      
      if (response.containsKey('token')) {
        token = response['token'];
        print('   ✓ Token found at response["token"]');
      }
      
      if (response.containsKey('role')) {
        role = response['role'];
        print('   ✓ Role found at response["role"]: $role');
      } else if (response.containsKey('user') && response['user'] != null) {
        if (response['user'] is Map && response['user'].containsKey('role')) {
          role = response['user']['role'];
          print('   ✓ Role found at response["user"]["role"]: $role');
        }
      }
      
      final tokenPreview = token != null && token.length > 20 ? token.substring(0, 20) : (token ?? 'NULL');
      print('🎫 Extracted Token: $tokenPreview...');
      print('👤 Extracted Role: $role');
      
      if (token == null) {
        throw Exception('No token received from server. Response: $response');
      }
      
      if (role == null) {
        throw Exception('No role received from server. Response: $response');
      }
      
      await ApiService.saveToken(token);
      await ApiService.saveUserRole(role);
      
      print('💾 Token and role saved successfully');
      print('🎉 Login successful! Navigating to main screen...');

      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      print('❌ Login error: $e');
      print('❌ Error type: ${e.runtimeType}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 32),
              
              CustomTextField(
                controller: _emailController,
                labelText: 'Email Address',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Password',
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
              
              SizedBox(height: 32),
              CustomButton(
                text: 'Login',
                onPressed: _login,
                isLoading: _isLoading,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


