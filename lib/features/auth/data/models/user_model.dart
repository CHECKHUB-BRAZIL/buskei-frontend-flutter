import '../../domain/entities/user_entity.dart';

/// Modelo de dados que representa um usuário na camada Data.
///
/// Este modelo é responsável por:
/// - Serializar/Deserializar JSON da API
/// - Converter para/de [UserEntity] (domínio)
/// - Lidar com dados específicos da API que não pertencem ao domínio
///
/// Diferenças entre [UserModel] e [UserEntity]:
/// - [UserModel]: contém campos técnicos (token, timestamps, etc)
/// - [UserEntity]: apenas dados de negócio
class UserModel {
  final String id;
  final String nome;
  final String email;
  final bool isActive;
  final String? token;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    this.isActive = true,
    this.token,
    this.createdAt,
    this.updatedAt,
  });

  /// Cria um [UserModel] a partir de um JSON.
  ///
  /// Exemplo esperado:
  /// ```json
  /// {
  ///   "id": "123",
  ///   "nome": "João Silva",
  ///   "email": "joao@example.com",
  ///   "is_active": true,
  ///   "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  ///   "created_at": "2024-01-15T10:30:00Z",
  ///   "updated_at": "2024-01-15T10:30:00Z"
  /// }
  /// ```
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      isActive: json['is_active'] as bool? ?? true,
      token: json['token'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  /// Converte o [UserModel] para JSON.
  ///
  /// Usado para salvar localmente ou enviar ao backend.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'is_active': isActive,
      if (token != null) 'token': token,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }

  /// Converte o [UserModel] em [UserEntity] (domínio).
  ///
  /// Remove dados técnicos (timestamps, flags da API) e mantém
  /// apenas informações relevantes para as regras de negócio.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      nome: nome,
      email: email,
      isActive: isActive,
      token: token,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    );
  }

  /// Cria um [UserModel] a partir de uma [UserEntity].
  ///
  /// Útil quando precisamos persistir uma entidade de domínio.
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      nome: entity.nome,
      email: entity.email,
      isActive: entity.isActive,
      token: entity.token,
      createdAt: entity.createdAt?.toIso8601String(),
    );
  }

  /// Cria uma cópia do model com alterações específicas
  UserModel copyWith({
    String? id,
    String? nome,
    String? email,
    bool? isActive,
    String? token,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
