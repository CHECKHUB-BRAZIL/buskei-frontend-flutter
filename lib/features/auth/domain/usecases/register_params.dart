/// Parâmetros necessários para executar o caso de uso de registro de usuário.
/// 
/// Essa classe concentra todos os dados que a operação de cadastro precisa,
/// garantindo uma tipagem forte e facilitando manutenção e testes.
/// 
/// [nome] Nome completo do usuário.
/// [email] E-mail que será utilizado para autenticação.
/// [senha] Senha de acesso criada pelo usuário.
class RegisterParams {
  final String nome;
  final String email;
  final String senha;

  RegisterParams({
    required this.nome,
    required this.email,
    required this.senha,
  });
}
