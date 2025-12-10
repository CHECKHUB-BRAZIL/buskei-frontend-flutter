import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<UserEntity> login(String email, String senha) async {
    final data = await datasource.login(email, senha);

    return UserEntity(
      id: data["id"],
      email: data["email"],
    );
  }

  @override
  Future<UserEntity> register(String email, String senha) async {
    final data = await datasource.register(email, senha);

    return UserEntity(
      id: data["id"],
      email: data["email"],
    );
  }
}
