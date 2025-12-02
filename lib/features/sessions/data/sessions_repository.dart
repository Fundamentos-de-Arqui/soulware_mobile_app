import 'package:soulware_app/features/sessions/data/sessions_api.dart';
import 'package:soulware_app/features/sessions/domain/models/session_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SessionsRepository {
  final SessionsApi api;
  SessionsRepository(this.api);

  Future<List<SessionModel>> fetchSessions({
    required int page,
    required int size,
    String? therapistId,
    String? patientId,
    String? legalResponsibleId,
  }) async {
    final uri = api.buildSessionsUri(
      page: page,
      size: size,
      therapistId: therapistId,
      patientId: patientId,
      legalResponsibleId: legalResponsibleId,
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }

    final Map<String, dynamic> json = jsonDecode(response.body);

    // items está dentro de "data"
    final List<dynamic> items = json["data"]["items"];

    return items
        .map((item) => SessionModel.fromJson(item))
        .toList();
  }

  Future<void> updateSessionStatus(int id, String status) async {
    return api.updateSessionStatus(id, status);
  }


}
