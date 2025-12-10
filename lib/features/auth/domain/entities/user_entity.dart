class UserEntity {
  final String id;
  final String nome;
  final String email;
  final bool isActive;

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

  UserEntity deactivate() {
    return UserEntity(
      id: id,
      email: email,
      nome: nome,
      isActive: false,
    );
  }

  bool canLogin() {
    return isActive;
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is UserEntity &&
        runtimeType == other.runtimeType &&
        id == other.id;

  @override
  int get hashCode => id.hashCode;
}
