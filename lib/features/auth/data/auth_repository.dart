import 'package:soulware_app/features/auth/domain/models/auth_tokens.dart';

import 'auth_api.dart';

class AuthRepository {
  final AuthApi api;

  AuthRepository(this.api);

  Future<AuthTokens> login(String dni, String password) async {
    final json = await api.login(dni, password);
    return AuthTokens.fromJson(json);
  }

}

