import 'package:flutter/material.dart';

/// Campo de texto reutilizável da aplicação.
///
/// O [CustomInput] encapsula um [TextFormField] com estilo padronizado,
/// suporte a validação, controle de foco e opção de ocultar texto
/// (ideal para senhas).
///
/// Características:
/// - Estilo visual consistente em toda a aplicação
/// - Suporte a validação de formulário
/// - Controle de foco
/// - Suporte a ícones prefixados e sufixados
/// - Alternância de visibilidade para campos do tipo senha
///
/// Ideal para:
/// - Formulários de login, cadastro e edição
/// - Campos de texto comuns e campos sensíveis (senha)
class CustomInput extends StatefulWidget {
  /// Texto exibido como hint (placeholder).
  final String hint;

  /// Controlador responsável pelo valor do campo.
  final TextEditingController controller;

  /// Define se o texto deve ser ocultado (ex: senha).
  final bool obscure;

  /// Tipo de teclado exibido (email, texto, número, etc).
  final TextInputType keyboardType;

  /// Ação do botão "Enter" do teclado.
  final TextInputAction textInputAction;

  /// Ícone exibido antes do texto (lado esquerdo).
  final Widget? prefixIcon;

  /// Ícone exibido após o texto (lado direito).
  ///
  /// Ignorado caso [obscure] seja `true`, pois o campo
  /// exibirá automaticamente o botão de mostrar/ocultar senha.
  final Widget? suffixIcon;

  /// Função de validação do campo.
  ///
  /// Retorna uma string com a mensagem de erro ou `null`
  /// caso o valor seja válido.
  final String? Function(String?)? validator;

  /// Callback chamado ao submeter o campo via teclado.
  final void Function(String)? onFieldSubmitted;

  /// Nó de foco do campo.
  ///
  /// Permite controle de navegação entre campos.
  final FocusNode? focusNode;

  /// Cria uma instância de [CustomInput].
  ///
  /// Apenas [hint] e [controller] são obrigatórios.
  const CustomInput({
    super.key,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onFieldSubmitted,
    this.focusNode,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

/// Estado interno do [CustomInput].
///
/// Responsável apenas por controlar a visibilidade do texto
/// quando o campo é do tipo senha.
class _CustomInputState extends State<CustomInput> {
  /// Controla se o texto está oculto ou visível.
  late bool _isObscured;

  @override
  void initState() {
    super.initState();

    // Inicializa o estado de visibilidade com base na configuração do widget
    _isObscured = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,

      decoration: InputDecoration(
        /// Texto de placeholder
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 16,
        ),

        /// Ícone à esquerda
        prefixIcon: widget.prefixIcon,

        /// Ícone à direita
        ///
        /// Se for um campo de senha, exibe o botão
        /// para alternar a visibilidade do texto.
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(
                  _isObscured
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : widget.suffixIcon,

        /// Estilo de fundo
        filled: true,
        fillColor: const Color(0xFFF5F5F5),

        /// Borda padrão
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        /// Borda quando habilitado
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        /// Borda quando focado
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF0057FF),
            width: 2,
          ),
        ),

        /// Borda em estado de erro
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),

        /// Borda em erro com foco
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),

        /// Espaçamento interno do campo
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
    );
  }
}
