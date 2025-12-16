import 'package:equatable/equatable.dart';

/// Classe base para representar falhas na aplicação.
///
/// Todas as falhas devem estender esta classe para
/// manter consistência no tratamento de erros.
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, [this.statusCode]);

  @override
  List<Object?> get props => [message, statusCode];
}

/// Falha de servidor (5xx ou erro da API)
class ServerFailure extends Failure {
  const ServerFailure([
    String message = 'Erro no servidor. Tente novamente mais tarde.',
    int? statusCode,
  ]) : super(message, statusCode);
}

/// Falha de conexão de rede
class NetworkFailure extends Failure {
  const NetworkFailure([
    String message = 'Sem conexão com a internet.',
  ]) : super(message);
}

/// Falha de validação de dados
class ValidationFailure extends Failure {
  const ValidationFailure([
    String message = 'Dados inválidos.',
  ]) : super(message);
}

/// Falha de autenticação (401)
class AuthFailure extends Failure {
  const AuthFailure([
    String message = 'Credenciais inválidas.',
  ]) : super(message, 401);
}

/// Falha de permissão (403)
class PermissionFailure extends Failure {
  const PermissionFailure([
    String message = 'Você não tem permissão para realizar esta ação.',
  ]) : super(message, 403);
}

/// Falha de recurso não encontrado (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure([
    String message = 'Recurso não encontrado.',
  ]) : super(message, 404);
}

/// Falha de conflito (409) - ex: email já cadastrado
class ConflictFailure extends Failure {
  const ConflictFailure([
    String message = 'Este recurso já existe.',
  ]) : super(message, 409);
}

/// Falha de cache local
class CacheFailure extends Failure {
  const CacheFailure([
    String message = 'Erro ao acessar dados locais.',
  ]) : super(message);
}

/// Falha desconhecida
class UnknownFailure extends Failure {
  const UnknownFailure([
    String message = 'Ocorreu um erro inesperado.',
  ]) : super(message);
}
