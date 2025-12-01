import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;



class AuthApi {

  String baseUrl = dotenv.env['API_URL'] ?? "http://10.0.2.2:3000/api";

  late final authApiUrl = Uri.parse("$baseUrl/auth");
  
  Future<Map<String, dynamic>> login(String dni, String password) async {
    final url = Uri.parse("$authApiUrl/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "identityDocumentNumber": dni,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      print("Login successful: ${response.body}");
      return jsonDecode(response.body);
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }
}
