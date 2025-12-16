import 'package:equatable/equatable.dart';

/// Entidade principal que representa um usuário dentro da camada de domínio.
///
/// A [UserEntity] encapsula apenas regras de negócio e validações essenciais
/// que devem existir independentemente de framework, API ou banco.
///
/// Características:
/// - Imutável (todas as propriedades são finais).
/// - Usa [Equatable] para comparações eficientes.
/// - Possui métodos que expressam regras de negócio.
///
/// Esta entidade é usada pelas camadas:
/// - Domain (UseCases)
/// - Data (Models convertem para/desde esta entidade)
/// - Presentation (Controllers consomem esta entidade)
class UserEntity extends Equatable {
  /// Identificador único do usuário.
  final String id;

  /// Nome do usuário.
  final String nome;

  /// Email válido do usuário.
  final String email;

  /// Indica se o usuário está ativo no sistema.
  final bool isActive;

  /// Token de autenticação (opcional, pode estar em outra entidade)
  final String? token;

  /// Data de criação da conta
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.nome,
    required this.email,
    this.isActive = true,
    this.token,
    this.createdAt,
  });

  /// Retorna uma nova instância do usuário, porém desativado.
  ///
  /// Como a entidade é imutável, não é possível alterar `isActive`
  /// diretamente — então retornamos uma nova entidade com a propriedade alterada.
  UserEntity deactivate() {
    return copyWith(isActive: false);
  }

  /// Ativa o usuário novamente
  UserEntity activate() {
    return copyWith(isActive: true);
  }

  /// Regra de negócio simples:
  /// retorna `true` se o usuário estiver ativo e puder fazer login.
  bool canLogin() => isActive;

  /// Verifica se o usuário tem um token válido
  bool get isAuthenticated => token != null && token!.isNotEmpty;

  /// Verifica se o nome do usuário é válido
  bool get hasValidName => nome.isNotEmpty && nome.length >= 2;

  /// Verifica se o email tem formato básico válido
  bool get hasValidEmail => email.contains('@') && email.length >= 5;

  /// Cria uma cópia da entidade com alterações específicas
  UserEntity copyWith({
    String? id,
    String? nome,
    String? email,
    bool? isActive,
    String? token,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Remove dados sensíveis (usado para logs, por exemplo)
  UserEntity sanitize() {
    return copyWith(token: null);
  }

  @override
  List<Object?> get props => [id, nome, email, isActive, token, createdAt];

  @override
  bool get stringify => true;
}
