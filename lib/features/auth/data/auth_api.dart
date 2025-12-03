import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  String baseUrl = dotenv.env['API_URL'] ?? "http://10.0.2.2:3000/api";
  late final url = Uri.parse("$baseUrl/login");

  Future<Map<String, dynamic>> login(String dni, String password) async {

    // ✅ MOCK: respuesta simulada SIN LLAMAR A LA API REAL
    if (dni == "25468731" && password == "password123") {
      return {
        "id": 1,
        "accountType": "THERAPIST",
        "token":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.KMUFsIDTnFmyG3nMiGM6H9FNFUROf3wh7SmqJp-QV30",
        "message": "Login successful",
        "profileId": 1
      };
    }

    if (dni == "18456723" && password == "password123") {
      return {
        "id": 1,
        "accountType": "LEGAL_RESPONSIBLE",
        "token":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.KMUFsIDTnFmyG3nMiGM6H9FNFUROf3wh7SmqJp-QV30",
        "message": "Login successful",
        "profileId": 1
      };
    }

    // Si quieres mockear también cuando está mal:
    return {
      "message": "Credenciales incorrectas",
      "error": true
    };

    // ❌ Si quieres que NO llame al backend mientras mockeas, 
    // simplemente NO ejecutes el código de abajo.
    /*
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
      return jsonDecode(response.body);
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
    */
  }
}
