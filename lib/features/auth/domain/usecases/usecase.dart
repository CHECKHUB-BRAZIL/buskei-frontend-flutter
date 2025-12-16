import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';

/// Interface base para todos os Use Cases da aplicação.
///
/// Define um contrato padrão onde:
/// - [Type]: tipo de retorno do caso de uso
/// - [Params]: parâmetros necessários para executar o caso de uso
///
/// Exemplo:
/// ```dart
/// class LoginUseCase implements UseCase<UserEntity, LoginParams> {
///   @override
///   Future<Either<Failure, UserEntity>> call(LoginParams params) async {
///     // implementação
///   }
/// }
/// ```
abstract class UseCase<Type, Params> {
  /// Executa o caso de uso com os parâmetros fornecidos.
  ///
  /// Retorna [Either<Failure, Type>] onde:
  /// - [Left]: representa uma falha
  /// - [Right]: representa sucesso com o valor do tipo [Type]
  Future<Either<Failure, Type>> call(Params params);
}

/// Classe auxiliar para Use Cases que não precisam de parâmetros.
///
/// Exemplo de uso:
/// ```dart
/// class GetCurrentUserUseCase implements UseCase<UserEntity, NoParams> {
///   @override
///   Future<Either<Failure, UserEntity>> call(NoParams params) async {
///     return await repository.getCurrentUser();
///   }
/// }
/// ```
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
