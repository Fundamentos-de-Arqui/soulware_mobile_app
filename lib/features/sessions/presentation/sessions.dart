import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulware_app/features/sessions/data/sessions_api.dart';
import 'package:soulware_app/features/sessions/data/sessions_repository.dart';
import 'package:soulware_app/features/sessions/domain/services/session_service.dart';
import 'package:soulware_app/features/sessions/domain/usecases/get_sessions_usecase.dart';


// API
final sessionsApiProvider = Provider((ref) => SessionsApi());

// Repository
final sessionsRepositoryProvider = Provider(
  (ref) => SessionsRepository(ref.read(sessionsApiProvider)),
);

// Service
final sessionsServiceProvider = Provider(
  (ref) => SessionsService(ref.read(sessionsRepositoryProvider)),
);

// UseCase
final fetchSessionsUseCaseProvider = Provider(
  (ref) => FetchSessionsUseCase(ref.read(sessionsServiceProvider)),
);
