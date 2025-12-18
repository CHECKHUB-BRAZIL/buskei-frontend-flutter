import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/auth_controller.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_overlay.dart';

/// Página de Cadastro de Usuário.
///
/// Responsável por:
/// - Exibir formulário de criação de conta
/// - Validar os dados informados pelo usuário
/// - Garantir confirmação de senha
/// - Exigir aceite dos termos de uso
/// - Disparar o fluxo de cadastro via [AuthController]
///
/// Arquitetura:
/// - Gerenciamento de estado com GetX
/// - Separação clara entre UI e lógica de negócio
/// - Uso de componentes reutilizáveis para inputs, botões e loading
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  /// Chave global para controle e validação do formulário
  final _formKey = GlobalKey<FormState>();

  /// Controllers dos campos de texto
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// FocusNodes para controle de navegação entre os campos
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  /// Indica se o usuário aceitou os termos e a política de privacidade
  bool _acceptedTerms = false;

  /// Libera os recursos alocados pelos controllers e focus nodes
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  /// Manipula o fluxo de cadastro:
  /// - Remove o foco dos campos
  /// - Valida o formulário
  /// - Verifica aceite dos termos
  /// - Dispara o cadastro via [AuthController]
  Future<void> _handleRegister() async {
    // Remove foco dos campos
    _nameFocus.unfocus();
    _emailFocus.unfocus();
    _passwordFocus.unfocus();
    _confirmPasswordFocus.unfocus();

    // Valida formulário
    if (!_formKey.currentState!.validate()) return;

    // Verifica se os termos foram aceitos
    if (!_acceptedTerms) {
      Get.snackbar(
        'Atenção',
        'Você precisa aceitar os termos para continuar',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Recupera o controller de autenticação
    final controller = Get.find<AuthController>();

    // Dispara o cadastro
    await controller.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<AuthController>(
        builder: (controller) {
          return LoadingOverlay(
            /// Exibe overlay enquanto o cadastro está em andamento
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
                      children: [
                        _buildLogo(),
                        const SizedBox(height: 26),
                        _buildRegisterForm(),
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

  /// Constrói o logo e o título da tela de cadastro
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

  /// Constrói o card do formulário de cadastro
  Widget _buildRegisterForm() {
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
          children: [
            _buildTitle(),
            const SizedBox(height: 32),
            _buildNameField(),
            const SizedBox(height: 16),
            _buildEmailField(),
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 16),
            _buildConfirmPasswordField(),
            const SizedBox(height: 4),
            _buildTermsCheckbox(),
            const SizedBox(height: 24),
            GetX<AuthController>(
              builder: (controller) {
                return CustomButton(
                  text: controller.isLoading.value
                      ? "Criando conta..."
                      : "Criar conta",
                  isLoading: controller.isLoading.value,
                  onPressed:
                      controller.isLoading.value ? null : _handleRegister,
                  icon: Icons.person_add_alt_1,
                );
              },
            ),
            const SizedBox(height: 24),
            _buildLoginLink(),
          ],
        ),
      ),
    );
  }

  /// Título do formulário
  Widget _buildTitle() {
    return Text(
      "Cadastro",
      style: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1B1E28),
      ),
    );
  }

  /// Campo de nome completo
  Widget _buildNameField() {
    return CustomInput(
      hint: "Nome completo",
      controller: _nameController,
      focusNode: _nameFocus,
      textInputAction: TextInputAction.next,
      prefixIcon: const Icon(Icons.person_outline),
      validator: (value) =>
          value == null || value.isEmpty ? 'Informe seu nome' : null,
      onFieldSubmitted: (_) => _emailFocus.requestFocus(),
    );
  }

  /// Campo de email com validação básica
  Widget _buildEmailField() {
    return CustomInput(
      hint: "Email",
      controller: _emailController,
      focusNode: _emailFocus,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: const Icon(Icons.email_outlined),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Informe seu email';
        if (!value.contains('@')) return 'Email inválido';
        return null;
      },
      onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
    );
  }

  /// Campo de senha
  Widget _buildPasswordField() {
    return CustomInput(
      hint: "Senha",
      controller: _passwordController,
      focusNode: _passwordFocus,
      obscure: true,
      textInputAction: TextInputAction.next,
      prefixIcon: const Icon(Icons.lock_outline),
      validator: (value) {
        if (value == null || value.length < 6) {
          return 'Senha deve ter no mínimo 6 caracteres';
        }
        return null;
      },
      onFieldSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
    );
  }

  /// Campo de confirmação de senha
  Widget _buildConfirmPasswordField() {
    return CustomInput(
      hint: "Confirmar senha",
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordFocus,
      obscure: true,
      textInputAction: TextInputAction.done,
      prefixIcon: const Icon(Icons.lock_outline),
      validator: (value) {
        if (value != _passwordController.text) {
          return 'As senhas não coincidem';
        }
        return null;
      },
      onFieldSubmitted: (_) => _handleRegister(),
    );
  }

  /// Checkbox de aceite dos termos de uso
  Widget _buildTermsCheckbox() {
    return CheckboxListTile(
      value: _acceptedTerms,
      onChanged: (value) {
        setState(() => _acceptedTerms = value ?? false);
      },
      title: Text(
        "Aceito os termos e a política de privacidade",
        style: GoogleFonts.inter(fontSize: 14),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  /// Link para retornar à tela de login
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Já tem uma conta? ",
          style: GoogleFonts.inter(fontSize: 14),
        ),
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Entrar",
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
