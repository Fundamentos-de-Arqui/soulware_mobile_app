import 'package:soulware_app/features/sessions/domain/models/session_model.dart';

class SessionsState {
  final bool loading;
  final List<SessionModel> sessions;
  final String? error;

  SessionsState({
    this.loading = false,
    this.sessions = const [],
    this.error,
  });

  factory SessionsState.initial() => SessionsState();

  SessionsState copyWith({
    bool? loading,
    List<SessionModel>? sessions,
    String? error,
  }) {
    return SessionsState(
      loading: loading ?? this.loading,
      sessions: sessions ?? this.sessions,
      error: error,
    );
  }
}
