import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulware_app/features/sessions/domain/usecases/update_session_status_usecase.dart';
import 'package:soulware_app/features/sessions/presentation/sessions.dart';
import 'package:soulware_app/features/sessions/presentation/sessions_state.dart';

class SessionsController extends Notifier<SessionsState> {
  @override
  SessionsState build() {
    return SessionsState.initial();
  }

  Future<void> loadSessions({
    required int page,
    required int size,
    String? therapistId,
    String? patientId,
    String? legalResponsibleId,
  }) async {
    final fetchSessions = ref.read(fetchSessionsUseCaseProvider);

    state = state.copyWith(loading: true, error: null);

    try {
      final result = await fetchSessions(
        page: page,
        size: size,
        therapistId: therapistId,
        patientId: patientId,
        legalResponsibleId: legalResponsibleId,
      );

      state = state.copyWith(loading: false, sessions: result);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> updateStatus(int id) async {
    final updateStatus = ref.read(updateSessionStatusUseCaseProvider);

    try {
      state = state.copyWith(loading: true);

      await updateStatus(id: id, status: "DONE");

      // Refrescar
      await loadSessions(page: 0, size: 20);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}

// Provider del controller
final sessionsControllerProvider =
    NotifierProvider<SessionsController, SessionsState>(SessionsController.new);
