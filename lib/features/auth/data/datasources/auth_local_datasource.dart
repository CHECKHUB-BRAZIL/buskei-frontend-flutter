import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Interface que define as operações locais de autenticação.
///
/// Responsável por:
/// - Armazenar/recuperar tokens de forma segura
/// - Cachear dados do usuário
/// - Gerenciar sessão local
abstract class AuthLocalDataSource {
  /// Salva o token de acesso
  Future<void> saveAccessToken(String token);

  /// Salva o token de refresh
  Future<void> saveRefreshToken(String token);

  /// Recupera o token de acesso
  Future<String?> getAccessToken();

  /// Recupera o token de refresh
  Future<String?> getRefreshToken();

  /// Salva os dados do usuário em cache
  Future<void> cacheUser(UserModel user);

  /// Recupera os dados do usuário do cache
  Future<UserModel?> getCachedUser();

  /// Remove todos os dados de autenticação
  Future<void> clearAuthData();

  /// Verifica se há um usuário autenticado
  Future<bool> isAuthenticated();
}

/// Implementação concreta usando FlutterSecureStorage.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;

  // Keys para o storage
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _cachedUserKey = 'cached_user';

  AuthLocalDataSourceImpl({required this.storage});

  @override
  Future<void> saveAccessToken(String token) async {
    try {
      await storage.write(key: _accessTokenKey, value: token);
    } catch (e) {
      throw CacheException('Erro ao salvar token de acesso: $e');
    }
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    try {
      await storage.write(key: _refreshTokenKey, value: token);
    } catch (e) {
      throw CacheException('Erro ao salvar token de refresh: $e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await storage.read(key: _accessTokenKey);
    } catch (e) {
      throw CacheException('Erro ao recuperar token de acesso: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await storage.read(key: _refreshTokenKey);
    } catch (e) {
      throw CacheException('Erro ao recuperar token de refresh: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await storage.write(key: _cachedUserKey, value: userJson);
    } catch (e) {
      throw CacheException('Erro ao cachear usuário: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = await storage.read(key: _cachedUserKey);

      if (userJson == null) return null;

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      throw CacheException('Erro ao recuperar usuário do cache: $e');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await Future.wait([
        storage.delete(key: _accessTokenKey),
        storage.delete(key: _refreshTokenKey),
        storage.delete(key: _cachedUserKey),
      ]);
    } catch (e) {
      throw CacheException('Erro ao limpar dados de autenticação: $e');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
