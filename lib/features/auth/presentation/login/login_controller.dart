
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulware_app/core/services/session_provider.dart';
import 'package:soulware_app/features/auth/auth.dart';
import 'package:soulware_app/features/auth/presentation/login/login_state.dart';

class LoginController extends Notifier<LoginState> {
  
  @override
  LoginState build() {

    return LoginState.initial();
  }

  Future<void> login(String dni, String password) async {

    final session = ref.read(sessionServiceProvider);
    final loginUser = ref.read(loginUserProvider);

    state = state.copyWith(loading: true, error: null);

    try {
      final tokens = await loginUser(dni, password);
      await session.saveTokens(tokens.token, tokens.accountType, tokens.profileId);
      state = state.copyWith(loading: false, tokens: tokens);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    final session = ref.read(sessionServiceProvider);
    await session.logout();
    state = LoginState.initial();
  }
}
