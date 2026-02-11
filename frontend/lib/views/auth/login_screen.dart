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

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 450),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Name
                    Text(
                      'Compus Connect',
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 8),
                    
                    // Welcome Text
                    Text(
                      'Welcome Back!',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 48),
                    
                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email Address',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    
                    // Password Field with Eye Button
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.deepPurple),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      style: GoogleFonts.poppins(),
                    ),
                    
                    SizedBox(height: 32),
                    
                    // Login Button
                    CustomButton(
                      text: 'Login',
                      onPressed: _login,
                      isLoading: _isLoading,
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


