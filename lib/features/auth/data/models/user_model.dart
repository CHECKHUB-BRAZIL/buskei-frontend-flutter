import '../../domain/entities/user_entity.dart';

/// Modelo responsável pela representação de usuário
/// na camada Data.
///
/// Responsabilidades:
/// - Serializar e desserializar respostas da API
/// - Adaptar dados externos para o domínio
/// - Converter entre JSON ↔ UserEntity
/// - Armazenar informações técnicas da aplicação
///   (tokens, timestamps, flags, etc)
///
/// Diferenças entre Model e Entity:
///
/// [UserModel]
/// - Estrutura orientada à API
/// - Contém campos técnicos
/// - Conhece o formato do backend
///
/// [UserEntity]
/// - Estrutura orientada ao domínio
/// - Contém apenas dados relevantes para regras de negócio
/// - Independe da API/backend
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

  /// Cria um [UserModel] a partir de um JSON retornado pela API.
  ///
  /// Exemplo esperado:
  ///
  /// ```json
  /// {
  ///   "id": "123",
  ///   "nome": "João Silva",
  ///   "email": "joao@example.com",
  ///   "is_active": true,
  ///   "token": "jwt-token",
  ///   "created_at": "2024-01-15T10:30:00Z",
  ///   "updated_at": "2024-01-15T10:30:00Z"
  /// }
  /// ```
  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      throw FormatException(
        'UserModel: campo "id" ausente',
      );
    }

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

  /// Converte o model para JSON.
  ///
  /// Utilizado para:
  /// - cache local
  /// - persistência
  /// - envio para APIs
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

  /// Converte o model para entidade de domínio.
  ///
  /// Mantém apenas informações relevantes para
  /// regras de negócio e autenticação da aplicação.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      nome: nome,
      email: email,
      isActive: isActive,
      token: token,
      createdAt:
          createdAt != null
              ? DateTime.tryParse(createdAt!)
              : null,
    );
  }

  /// Cria um [UserModel] a partir de uma [UserEntity].
  ///
  /// Útil para persistência local ou adaptação
  /// de dados do domínio para a camada Data.
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

  /// Cria uma cópia do model com alterações parciais.
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
