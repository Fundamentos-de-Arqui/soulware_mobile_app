


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soulware_app/features/auth/data/auth_api.dart';
import 'package:soulware_app/features/auth/data/auth_repository.dart';
import 'package:soulware_app/features/auth/domain/usecases/login_user.dart';
import 'package:soulware_app/features/auth/presentation/login/login_controller.dart';
import 'package:soulware_app/features/auth/presentation/login/login_state.dart';

final authApiProvider = Provider((ref) => AuthApi());

final authRepositoryProvider = Provider((ref) => AuthRepository(ref.read(authApiProvider)));

final loginUserProvider = Provider((ref) => LoginUser(ref.read(authRepositoryProvider)));

final loginControllerProvider = NotifierProvider<LoginController, LoginState>(
  () => LoginController(),
);

