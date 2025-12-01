import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService {
  static const _storage = FlutterSecureStorage();

  Future<void> saveTokens(String accessToken, String role, int profileId) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'role', value: role);
    await _storage.write(key: 'profileId', value: profileId.toString());
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<bool> isLogged() async {
    final t = await getAccessToken();
    return t != null;
  }

  Future<String?> getRole() async {
    return await _storage.read(key: 'role');
  }

  Future<int?> getProfileId() async {
    final idStr = await _storage.read(key: 'profileId');
    if (idStr != null) {
      return int.tryParse(idStr);
    }
    return null;
  }
}