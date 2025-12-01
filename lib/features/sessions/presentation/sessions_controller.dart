import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulware_app/core/services/session_provider.dart';
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

    final profileId = await ref.read(sessionServiceProvider).getProfileId();


    try {
      final result = await fetchSessions(
        page: page,
        size: size,
        therapistId: profileId?.toString(),
        patientId: patientId,
        legalResponsibleId: legalResponsibleId,
      );

      state = state.copyWith(
        loading: false,
        sessions: result,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: e.toString(),
      );
    }
  }
}

// Provider del controller
final sessionsControllerProvider =
    NotifierProvider<SessionsController, SessionsState>(
  SessionsController.new,
);
