
import 'package:soulware_app/features/sessions/domain/models/session_model.dart';
import 'package:soulware_app/features/sessions/domain/services/session_service.dart';

class FetchSessionsUseCase {
  final SessionsService service;

  FetchSessionsUseCase(this.service);

  Future<List<SessionModel>> call({
    required int page,
    required int size,
    String? therapistId,
    String? patientId,
    String? legalResponsibleId,
  }) {
    return service.getSessions(
      page: page,
      size: size,
      therapistId: therapistId,
      patientId: patientId,
      legalResponsibleId: legalResponsibleId,
    );
  }
}
