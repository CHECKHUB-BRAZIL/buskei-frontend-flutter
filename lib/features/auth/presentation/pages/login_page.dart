import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';
import '../widgets/social_login_buttons.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_overlay.dart';

/// Página de Login da aplicação.
///
/// Responsável por:
/// - Exibir formulário de autenticação (email e senha)
/// - Validar os campos de entrada
/// - Disparar o fluxo de login via [AuthController]
/// - Exibir estado de carregamento
/// - Oferecer opções de login social (em desenvolvimento)
///
/// Arquitetura:
/// - UI desacoplada da lógica de negócio
/// - Estado gerenciado via GetX
/// - Componentes reutilizáveis (inputs, botões, overlay)
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Chave global para controle e validação do formulário
  final _formKey = GlobalKey<FormState>();

  /// Controller do campo de email
  final _emailController = TextEditingController();

  /// Controller do campo de senha
  final _senhaController = TextEditingController();

  /// FocusNode do campo de email
  final _emailFocusNode = FocusNode();

  /// FocusNode do campo de senha
  final _senhaFocusNode = FocusNode();

  /// Libera os recursos alocados pelos controllers e focus nodes
  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _emailFocusNode.dispose();
    _senhaFocusNode.dispose();
    super.dispose();
  }

  /// Manipula o fluxo de login:
  /// - Remove o foco dos campos
  /// - Valida o formulário
  /// - Chama o método de login no [AuthController]
  Future<void> _handleLogin() async {
    // Remove foco dos campos para fechar o teclado
    _emailFocusNode.unfocus();
    _senhaFocusNode.unfocus();

    // Valida formulário antes de prosseguir
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Recupera o controller de autenticação
    final controller = Get.find<AuthController>();

    // Dispara o login
    await controller.login(
      _emailController.text.trim(),
      _senhaController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<AuthController>(
        builder: (controller) {
          return LoadingOverlay(
            /// Exibe overlay enquanto o login está em andamento
            isLoading: controller.isLoading.value,
            child: Container(
              decoration: const BoxDecoration(
                /// Gradiente de fundo da tela
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0057FF),
                    Color(0xFF4779DD),
                  ],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLogo(),
                        const SizedBox(height: 20),
                        _buildLoginForm(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Constrói o logo e mensagem de boas-vindas
  Widget _buildLogo() {
    return Column(
      children: [
        Text(
          "Busquei",
          style: GoogleFonts.inter(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }

  /// Constrói o card principal do formulário de login
  Widget _buildLoginForm() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFormTitle(),
            const SizedBox(height: 32),
            _buildEmailField(),
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 12),
            _buildForgotPasswordButton(),
            const SizedBox(height: 24),
            _buildLoginButton(),
            const SizedBox(height: 24),
            _buildDivider(),
            const SizedBox(height: 24),
            _buildSocialButtons(),
            const SizedBox(height: 32),
            _buildRegisterLink(),
          ],
        ),
      ),
    );
  }

  /// Título do formulário
  Widget _buildFormTitle() {
    return Text(
      "Entrar",
      style: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1B1E28),
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Campo de email com validação
  Widget _buildEmailField() {
    return CustomInput(
      hint: "Email",
      controller: _emailController,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: const Icon(Icons.email_outlined),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira seu email';
        }
        if (!value.contains('@')) {
          return 'Email inválido';
        }
        return null;
      },
      onFieldSubmitted: (_) {
        _senhaFocusNode.requestFocus();
      },
    );
  }

  /// Campo de senha com opção de ocultar/exibir texto
  Widget _buildPasswordField() {
    return CustomInput(
      hint: "Senha",
      controller: _senhaController,
      focusNode: _senhaFocusNode,
      obscure: true,
      textInputAction: TextInputAction.done,
      prefixIcon: const Icon(Icons.lock_outline),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira sua senha';
        }
        if (value.length < 6) {
          return 'Senha deve ter no mínimo 6 caracteres';
        }
        return null;
      },
      onFieldSubmitted: (_) => _handleLogin(),
    );
  }

  /// Botão de recuperação de senha (ainda não implementado)
  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Get.snackbar(
            'Em breve',
            'Funcionalidade de recuperação de senha em desenvolvimento',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        child: Text(
          "Esqueceu a senha?",
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF0057FF),
          ),
        ),
      ),
    );
  }

  /// Botão principal de login
  Widget _buildLoginButton() {
    return CustomButton(
      text: "Entrar",
      onPressed: _handleLogin,
    );
  }

  /// Divisor visual entre login tradicional e social
  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "ou",
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF9E9E9E),
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
      ],
    );
  }

  /// Botões de login social (Google, Facebook e LinkedIn)
  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialLoginButton(
          assetPath: "assets/icon/google.svg",
          onTap: () {
            Get.snackbar(
              'Em breve',
              'Login com Google em desenvolvimento',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
        const SizedBox(width: 16),
        SocialLoginButton(
          icon: Icons.facebook,
          backgroundColor: const Color(0xFF1877F2),
          onTap: () {
            Get.snackbar(
              'Em breve',
              'Login com Facebook em desenvolvimento',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
        const SizedBox(width: 16),
        SocialLoginButton(
          assetPath: "assets/icon/linkedin.png",
          backgroundColor: const Color(0xFF0A66C2),
          onTap: () {
            Get.snackbar(
              'Em breve',
              'Login com LinkedIn em desenvolvimento',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      ],
    );
  }

  /// Link para navegação até a tela de cadastro
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Não tem uma conta? ",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF757575),
          ),
        ),
        TextButton(
          onPressed: () => Get.toNamed('/register'),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Cadastre-se",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0057FF),
            ),
          ),
        ),
      ],
    );
  }
}
