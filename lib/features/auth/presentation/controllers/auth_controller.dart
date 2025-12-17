import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/usecase.dart';

/// Controller responsável por gerenciar o estado de autenticação do usuário.
///
/// Atua como a camada de apresentação (Presentation Layer),
/// orquestrando chamadas aos casos de uso do domínio,
/// controlando estados reativos e navegação.
///
/// Não contém regras de negócio nem acesso direto a dados.
class AuthController extends GetxController {
  /// Caso de uso responsável pelo login do usuário
  final LoginUseCase loginUseCase;

  /// Caso de uso responsável pelo registro de um novo usuário
  final RegisterUseCase registerUseCase;

  /// Caso de uso responsável pelo logout do usuário
  final LogoutUseCase logoutUseCase;

  /// Caso de uso responsável por obter o usuário autenticado atual
  final GetCurrentUserUseCase getCurrentUserUseCase;

  /// Construtor com injeção de dependências dos casos de uso
  AuthController({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  });

  // ==========================
  // Estados reativos
  // ==========================

  /// Usuário atualmente autenticado.
  /// Será `null` quando não houver sessão ativa.
  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);

  /// Indica se alguma operação assíncrona está em andamento
  final RxBool isLoading = false.obs;

  /// Mensagem de erro atual, caso exista
  final RxString errorMessage = ''.obs;

  /// Indica se o usuário está autenticado
  final RxBool isAuthenticated = false.obs;

  /// Método chamado automaticamente ao iniciar o controller.
  ///
  /// Utilizado para verificar se já existe um usuário autenticado
  /// (por exemplo, token salvo ou sessão persistida).
  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  /// Verifica se há um usuário autenticado ao iniciar o app.
  ///
  /// Executa o [GetCurrentUserUseCase] e atualiza o estado
  /// de autenticação com base no resultado.
  Future<void> checkAuthStatus() async {
    isLoading.value = true;

    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      /// Caso ocorra falha (nenhum usuário autenticado)
      (failure) {
        isAuthenticated.value = false;
        currentUser.value = null;
      },

      /// Caso exista um usuário autenticado
      (user) {
        isAuthenticated.value = true;
        currentUser.value = user;
      },
    );

    isLoading.value = false;
  }

  /// Realiza o login do usuário.
  ///
  /// Recebe email e senha, executa o [LoginUseCase]
  /// e atualiza o estado conforme sucesso ou falha.
  ///
  /// Em caso de sucesso, navega para a rota `/home`.
  Future<void> login(String email, String senha) async {
    isLoading.value = true;
    errorMessage.value = '';

    final params = LoginParams(email: email, senha: senha);
    final result = await loginUseCase(params);

    result.fold(
      /// Caso de falha no login
      (failure) {
        errorMessage.value = failure.message;
        isAuthenticated.value = false;
        Get.snackbar('Erro', failure.message);
      },

      /// Caso de sucesso no login
      (user) {
        currentUser.value = user;
        isAuthenticated.value = true;
        Get.offAllNamed('/home');
      },
    );

    isLoading.value = false;
  }

  /// Realiza o registro de um novo usuário.
  ///
  /// Executa o [RegisterUseCase] com os dados informados.
  /// Em caso de sucesso, autentica automaticamente o usuário
  /// e navega para a rota `/home`.
  Future<void> register(String nome, String email, String senha) async {
    isLoading.value = true;
    errorMessage.value = '';

    final params = RegisterParams(
      nome: nome,
      email: email,
      senha: senha,
    );

    final result = await registerUseCase(params);

    result.fold(
      /// Caso de falha no registro
      (failure) {
        errorMessage.value = failure.message;
        Get.snackbar('Erro', failure.message);
      },

      /// Caso de sucesso no registro
      (user) {
        currentUser.value = user;
        isAuthenticated.value = true;
        Get.offAllNamed('/home');
      },
    );

    isLoading.value = false;
  }

  /// Realiza o logout do usuário.
  ///
  /// Executa o [LogoutUseCase], limpa o estado local
  /// e redireciona para a tela de login.
  Future<void> logout() async {
    isLoading.value = true;

    final result = await logoutUseCase(NoParams());

    result.fold(
      /// Caso ocorra falha no logout
      (failure) {
        Get.snackbar('Erro', failure.message);
      },

      /// Caso logout seja realizado com sucesso
      (_) {
        currentUser.value = null;
        isAuthenticated.value = false;
        Get.offAllNamed('/login');
      },
    );

    isLoading.value = false;
  }
}
