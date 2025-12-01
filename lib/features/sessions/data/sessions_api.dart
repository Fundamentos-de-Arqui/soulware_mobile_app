import 'package:flutter_dotenv/flutter_dotenv.dart';

class SessionsApi {
  final String baseUrl = dotenv.env['API_URL'] ?? "http://10.0.2.2:3000/api";

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
}
