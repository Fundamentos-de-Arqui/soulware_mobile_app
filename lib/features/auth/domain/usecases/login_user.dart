
import 'package:soulware_app/features/auth/data/auth_repository.dart';
import 'package:soulware_app/features/auth/domain/models/auth_tokens.dart';

class LoginUser {
  final AuthRepository repository;
  LoginUser(this.repository);

  Future<AuthTokens> call(String dni, String password) async {
    return await repository.login(dni, password); // devuelve AuthTokens
  }
}

