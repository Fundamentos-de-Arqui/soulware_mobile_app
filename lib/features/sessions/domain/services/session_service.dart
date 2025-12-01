import 'package:soulware_app/features/sessions/data/sessions_repository.dart';
import 'package:soulware_app/features/sessions/domain/models/session_model.dart';


class SessionsService {
  final SessionsRepository repository;

  SessionsService(this.repository);

  Future<List<SessionModel>> getSessions({
    required int page,
    required int size,
    String? therapistId,
    String? patientId,
    String? legalResponsibleId,
  }) async {
    // Ejemplo de lógica extra (si la necesitas):
    if (size > 200) {
      throw Exception("El tamaño máximo permitido es 200");
    }

    return await repository.fetchSessions(
      page: page,
      size: size,
      therapistId: therapistId,
      patientId: patientId,
      legalResponsibleId: legalResponsibleId,
    );
  }
}
