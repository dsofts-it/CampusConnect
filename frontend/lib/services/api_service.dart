import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://campusconnect-vweo.onrender.com/api'; 

  static Future<Map<String, dynamic>> signup(
      String name, String email, String password, String confirmPassword, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'role': role,
      }),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    print('🔐 Login API call starting...');
    print('📧 Email: $email');
    print('📡 URL: $baseUrl/auth/login');
    
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    
    print('📥 Login response status: ${response.statusCode}');
    print('📥 Login response body: ${response.body}');
    
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getProfile() async {
    print('');
    print('═══════════════════════════════════════════');
    print('👤 GETTING PROFILE - DETAILED DEBUG');
    print('═══════════════════════════════════════════');
    
    final token = await getToken();
    
    print('Step 1: Token Retrieved from Storage');
    print('  - Token exists: ${token != null}');
    if (token != null) {
      print('  - Token length: ${token.length}');
      print('  - First 10 chars: ${token.length >= 10 ? token.substring(0, 10) : token}');
      print('  - Last 10 chars: ${token.length >= 10 ? token.substring(token.length - 10) : token}');
      print('  - FULL TOKEN: $token');
    } else {
      print('  - ❌ TOKEN IS NULL!');
    }
    
    if (token == null) {
      print('❌ No token found in storage');
      print('═══════════════════════════════════════════');
      print('');
      throw Exception('No token found - please login again');
    }
    
    final url = '$baseUrl/users/me';
    final authHeader = 'Bearer $token';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': authHeader,
    };
    
    print('');
    print('Step 2: Preparing Request');
    print('  - URL: $url');
    print('  - Authorization Header: $authHeader');
    print('  - Header Length: ${authHeader.length}');
    print('  - Headers: ${headers.keys.toList()}');
    
    print('');
    print('Step 3: Sending Request...');
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    
    print('');
    print('Step 4: Response Received');
    print('  - Status Code: ${response.statusCode}');
    print('  - Status: ${response.statusCode == 200 ? "✅ OK" : "❌ ERROR"}');
    print('  - Body: ${response.body}');
    print('═══════════════════════════════════════════');
    print('');
    
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getAllUpdates({String? category, bool? isImportant}) async {
    print('📚 Getting all updates (PUBLIC - no auth required)...');
    
    String query = '';
    if (category != null) query += 'category=$category&';
    if (isImportant != null) query += 'isImportant=$isImportant&';

    final url = '$baseUrl/updates?$query';
    print('📡 Calling: $url');
    print('🔓 No authentication required for this endpoint');
    
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        // No Authorization header - this is a public endpoint
      },
    );
    
    print('📥 Updates response status: ${response.statusCode}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final preview = response.body.length > 200 ? response.body.substring(0, 200) : response.body;
      print('📥 Updates response body: $preview...');
    } else {
      print('📥 Updates error response: ${response.body}');
    }
    
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> createUpdate(Map<String, dynamic> data) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.post(
      Uri.parse('$baseUrl/updates'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }
  
  static Future<Map<String, dynamic>> likeUpdate(String updateId) async {
    final token = await getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.put(
      Uri.parse('$baseUrl/updates/$updateId/like'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }


  static Future<void> saveToken(String token) async {
    final savePreview = token.length > 20 ? token.substring(0, 20) : token;
    print('💾 Saving token: $savePreview...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('✅ Token saved successfully');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final preview = token.length > 20 ? token.substring(0, 20) : token;
      print('🔑 Token retrieved from storage: $preview...');
      print('🔍 FULL TOKEN (for debugging): $token');
      print('📏 Token length: ${token.length}');
      if (token.length > 10) {
        print('🔤 Token starts with: ${token.substring(0, 10)}');
      }
    } else {
      print('⚠️ No token found in storage');
    }
    return token;
  }

  static Future<void> removeToken() async {
    print('🗑️ Removing token and role...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    print('✅ Token and role removed');
  }
  
  static Future<void> saveUserRole(String role) async {
    print('💾 Saving user role: $role');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
    print('✅ Role saved successfully');
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    print('🔑 Role retrieved from storage: $role');
    return role;
  }


  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      // Try to parse error message
      try {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Something went wrong');
      } catch (e) {
        throw Exception('Server error: ${response.statusCode}');
      }
    }
  }
}
