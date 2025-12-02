import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class SessionsApi {
  final Dio _dio = Dio();

  final String baseUrl = dotenv.env['API_URL'] ?? "http://10.0.2.2:3000/api";

  SessionsApi() {
    _dio.options.baseUrl = baseUrl;
  }
  
  Uri buildSessionsUri({
    required int page,
    required int size,
    String? therapistId,
    String? patientId,
    String? legalResponsibleId,
  }) {
    final base = Uri.parse(baseUrl);

    return base.replace(
      path: '${base.path}/sessions',
      queryParameters: {
        'page': '$page',
        'size': '$size',
        if (therapistId != null) 'therapistId': therapistId,
        if (patientId != null) 'patientId': patientId,
        if (legalResponsibleId != null) 'legalResponsibleId': legalResponsibleId,
      },
    );
  }

  Future<void> updateSessionStatus(int id, String status) async {
  final response = await _dio.patch(
    "/sessions/status",
    data: {
      "id": id,
      "status": status,
    },
  );

  if (response.statusCode != 200) {
    throw Exception("Error updating status");
  }
}

}
