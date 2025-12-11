/// Entidade principal que representa um usuário dentro da camada de domínio.
///
/// A [UserEntity] encapsula apenas regras de negócio e validações essenciais
/// que devem existir independentemente de framework, API ou banco.
///
/// Características:
/// - Imutável (todas as propriedades são finais).
/// - Possui validações internas para nome e email.
/// - Possui métodos que expressam regras de negócio, como [deactivate] e [canLogin].
///
/// Esta entidade é usada pelas camadas:
/// - Domain (UseCases)
/// - Data (Models convertem para/desde esta entidade)
/// - Presentation (Controllers consomem esta entidade)
class UserEntity {
  /// Identificador único do usuário.
  final String id;

  /// Nome do usuário.
  final String nome;

  /// Email válido do usuário.
  final String email;

  /// Indica se o usuário está ativo no sistema.
  final bool isActive;

  /// Construtor da entidade.
  ///
  /// Executa validações essenciais:
  /// - Nome não pode ser vazio.
  /// - Email não pode ser vazio.
  /// - Email precisa conter '@'.
  ///
  /// Qualquer violação lança um [ArgumentError].
  UserEntity({
    required this.id,
    required this.nome,
    required this.email,
    this.isActive = true,
  }) {
    if (nome.isEmpty) {
      throw ArgumentError('Nome não pode ser vazio');
    }
    if (email.isEmpty) {
      throw ArgumentError('Email não pode ser vazio');
    }
    if (!email.contains('@')) {
      throw ArgumentError('Email inválido');
    }
  }

  /// Retorna uma nova instância do usuário, porém desativado.
  ///
  /// Como a entidade é imutável, não é possível alterar `isActive`
  /// diretamente — então retornamos uma nova entidade com a propriedade alterada.
  UserEntity deactivate() {
    return UserEntity(
      id: id,
      email: email,
      nome: nome,
      isActive: false,
    );
  }

  /// Regra de negócio simples:
  /// retorna `true` se o usuário estiver ativo e puder fazer login.
  bool canLogin() {
    return isActive;
  }

  /// Sobrescrita de igualdade para comparar usuários pelo seu `id`.
  ///
  /// Isso garante que duas entidades com o mesmo `id` sejam tratadas
  /// como o mesmo usuário dentro do domínio.
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is UserEntity &&
        runtimeType == other.runtimeType &&
        id == other.id;

  /// HashCode consistente com o operador `==`,
  /// garantindo comparações corretas em coleções (maps, sets, etc).
  @override
  int get hashCode => id.hashCode;
}
