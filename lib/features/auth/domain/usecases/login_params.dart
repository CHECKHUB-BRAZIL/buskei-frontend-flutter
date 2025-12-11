/// Parâmetros necessários para executar o caso de uso de login.
/// 
/// Representa os dados usados para autenticar um usuário no sistema.
/// 
/// [email] E-mail cadastrado.
/// [senha] Senha correspondente ao e-mail informado.
class LoginParams {
  final String email;
  final String senha;

  LoginParams({
    required this.email,
    required this.senha,
  });
}
