import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String email,
    required String senha,
  });

  Future<UserEntity> register({
    required String nome,
    required String email,
    required String senha,
  });
}
