  import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

  class TokenStorage {

    final FlutterSecureStorage _storage = const FlutterSecureStorage();

    static const String _refresh = "refresh_token";
    static const String _access = "access_token";

    Future<void> saveRefreshToken(String token) async {
      await _storage.write(key: _refresh, value: token);
    }

    Future<String?> getRefreshToken () async {
      return await _storage.read(key: _refresh);
    }

    Future<void> deleteRefreshToken() async {
      await _storage.delete(key: _refresh);
    }

    Future<void> saveAccessToken(String token) async {
      await _storage.write(key: _access, value: token);
    }

    Future<String?> getAccessToken() async {
      return await _storage.read(key: _access);
    }

    Future<void> deleteAccessToken() async {
      await _storage.delete(key: _access);
    }

  }

  final tokenStorageProvider = Provider<TokenStorage> ((ref) { return TokenStorage();});