import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/request/user_login_requestmodel.dart';
import '../models/request/user_register_requestmodel.dart';

/// Implementação concreta do [AuthRepository].
///
/// Responsabilidades desta classe:
/// - Implementar o contrato definido na camada de domínio
/// - Orquestrar chamadas entre datasource remoto e local
/// - Verificar conectividade antes de operações remotas
/// - Converter exceções técnicas em [Failure]s de domínio
/// - Gerenciar cache, tokens e estado de autenticação
///
/// ### Arquitetura
/// Esta classe pertence à **camada de Data** na Clean Architecture.
/// Ela **não conhece UI**, **não conhece controllers**
/// e **não expõe exceções**, apenas `Either<Failure, Success>`.
///
/// ### Tratamento de erros
/// - Exceptions → lançadas pelos datasources
/// - Failures → retornadas ao domínio via `Either`
class AuthRepositoryImpl implements AuthRepository {
  /// Datasource responsável por comunicação com a API
  final AuthRemoteDataSource remoteDataSource;

  /// Datasource responsável por cache local (tokens e usuário)
  final AuthLocalDataSource localDataSource;

  /// Serviço para verificação de conectividade de rede
  final Connectivity connectivity;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  /// Realiza o login do usuário.
  ///
  /// Fluxo:
  /// 1. Verifica conectividade
  /// 2. Cria o request model
  /// 3. Chama o endpoint remoto
  /// 4. Persiste tokens e usuário localmente
  /// 5. Retorna a entidade de domínio
  ///
  /// Retorna:
  /// - `Right<UserEntity>` em caso de sucesso
  /// - `Left<Failure>` em caso de erro
  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String senha,
  }) async {
    if (!await _hasConnection()) {
      return const Left(NetworkFailure());
    }

    try {
      final request = LoginRequestModel(
        email: email.trim(),
        senha: senha,
      );

      final response = await remoteDataSource.login(request);

      await Future.wait([
        localDataSource.saveAccessToken(response.accessToken),
        if (response.refreshToken != null)
          localDataSource.saveRefreshToken(response.refreshToken!),
        localDataSource.cacheUser(response.user),
      ]);

      return Right(response.user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(UnknownFailure('Erro ao fazer login: $e'));
    }
  }

  /// Registra um novo usuário.
  ///
  /// Fluxo semelhante ao login:
  /// - Criação do usuário no backend
  /// - Persistência de tokens
  /// - Cache do usuário
  ///
  /// Trata explicitamente conflitos de email duplicado (HTTP 409).
  @override
  Future<Either<Failure, UserEntity>> register({
    required String nome,
    required String email,
    required String senha,
  }) async {
    if (!await _hasConnection()) {
      return const Left(NetworkFailure());
    }

    try {
      final request = RegisterRequestModel(
        nome: nome.trim(),
        email: email.trim(),
        senha: senha,
      );

      final response = await remoteDataSource.register(request);

      await Future.wait([
        localDataSource.saveAccessToken(response.accessToken),
        if (response.refreshToken != null)
          localDataSource.saveRefreshToken(response.refreshToken!),
        localDataSource.cacheUser(response.user),
      ]);

      return Right(response.user.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      if (e.statusCode == 409) {
        return const Left(
          ConflictFailure('Este email já está cadastrado'),
        );
      }
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(UnknownFailure('Erro ao registrar usuário: $e'));
    }
  }

  /// Realiza logout do usuário.
  ///
  /// - Tenta invalidar sessão no backend (se houver conexão)
  /// - Sempre limpa os dados locais
  ///
  /// O logout local **não depende** do sucesso do logout remoto.
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final refreshToken = await localDataSource.getRefreshToken();

      if (refreshToken != null && await _hasConnection()) {
        try {
          await remoteDataSource.logout(refreshToken);
        } catch (_) {
          // best effort: não bloqueia logout local
        }
      }

      await localDataSource.clearAuthData();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure('Erro ao fazer logout: $e'));
    }
  }
  /// Retorna o usuário atualmente autenticado.
  ///
  /// Estratégia:
  /// 1. Tenta recuperar do cache local
  /// 2. Valida se existe token válido
  /// 3. Caso contrário, busca do backend
  /// 4. Atualiza cache
  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();

      if (cachedUser != null) {
        final hasToken = await localDataSource.isAuthenticated();
        if (hasToken) {
          return Right(cachedUser.toEntity());
        }
      }

      if (!await _hasConnection()) {
        return const Left(NetworkFailure());
      }

      final userModel = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheUser(userModel);

      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      await localDataSource.clearAuthData();
      return Left(AuthFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(UnknownFailure('Erro ao buscar usuário atual: $e'));
    }
  }

  /// Verifica se o usuário está autenticado localmente.
  ///
  /// Baseado apenas na existência e validade de tokens armazenados.
  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final isAuth = await localDataSource.isAuthenticated();
      return Right(isAuth);
    } catch (e) {
      return Left(CacheFailure('Erro ao verificar autenticação'));
    }
  }

  /// Renova o access token utilizando o refresh token.
  ///
  /// Em caso de falha:
  /// - Limpa dados locais
  /// - Retorna erro de autenticação
  @override
  Future<Either<Failure, String>> refreshToken() async {
    if (!await _hasConnection()) {
      return const Left(NetworkFailure());
    }

    try {
      final refreshToken = await localDataSource.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        return const Left(AuthFailure('Token de refresh não encontrado'));
      }

      final newAccessToken =
          await remoteDataSource.refreshToken(refreshToken);

      await localDataSource.saveAccessToken(newAccessToken);

      return Right(newAccessToken);
    } on AuthException catch (e) {
      await localDataSource.clearAuthData();
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(UnknownFailure('Erro ao renovar token: $e'));
    }
  }

  /// Atualiza dados do perfil do usuário.
  ///
  /// ⚠️ Ainda não implementado no backend.
  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? nome,
    String? email,
  }) async {
    if (!await _hasConnection()) {
      return const Left(NetworkFailure());
    }

    return const Left(
      ServerFailure('Funcionalidade não implementada'),
    );
  }

  /// Altera a senha do usuário.
  ///
  /// ⚠️ Ainda não implementado no backend.
  @override
  Future<Either<Failure, void>> changePassword({
    required String senhaAtual,
    required String novaSenha,
  }) async {
    if (!await _hasConnection()) {
      return const Left(NetworkFailure());
    }

    return const Left(
      ServerFailure('Funcionalidade não implementada'),
    );
  }

  /// Verifica se o dispositivo possui conexão com a internet.
  ///
  /// Retorna `true` se houver conexão via:
  /// - Wi-Fi
  /// - Dados móveis
  /// - Ethernet
  Future<bool> _hasConnection() async {
    try {
      final result = await connectivity.checkConnectivity();

      return result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle({
    required String idToken,
  }) async {
    if (!await _hasConnection()) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.loginWithGoogle(
        idToken: idToken,
      );

      final userEntity = response.user.toEntity();

      await Future.wait([
        localDataSource.saveAccessToken(response.accessToken),
        localDataSource.saveRefreshToken(response.refreshToken),
        localDataSource.cacheUser(response.user),
      ]);

      return Right(userEntity);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      return Left(
        UnknownFailure('Erro ao autenticar com Google: $e'),
      );
    }
  }
}
