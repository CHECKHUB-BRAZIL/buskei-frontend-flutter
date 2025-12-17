import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Botão reutilizável da aplicação.
///
/// O [CustomButton] encapsula o estilo padrão dos botões primários
/// do app, garantindo consistência visual e facilitando manutenção.
///
/// Características:
/// - Usa [ElevatedButton] como base.
/// - Estilo padronizado (cor, tipografia e bordas).
/// - Texto configurável.
/// - Callback obrigatório para ação do botão.
///
/// Ideal para:
/// - Ações principais (login, cadastro, confirmar, salvar, etc).
/// - Evitar repetição de estilos em múltiplas telas.
class CustomButton extends StatelessWidget {
  /// Texto exibido dentro do botão.
  final String text;

  /// Função executada ao pressionar o botão.
  final VoidCallback onPressed;

  /// Cria uma instância de [CustomButton].
  ///
  /// Parâmetros:
  /// - [text]: texto exibido no botão.
  /// - [onPressed]: callback chamado quando o botão é pressionado.
  ///
  /// Ambos são obrigatórios para garantir usabilidade e acessibilidade.
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        /// Cor de fundo do botão (primary action)
        backgroundColor: const Color(0xFF0057FF),

        /// Cor do texto e ícones
        foregroundColor: Colors.white,

        /// Espaçamento interno vertical
        padding: const EdgeInsets.symmetric(vertical: 16),

        /// Tipografia padrão do botão
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),

        /// Bordas arredondadas
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      /// Texto exibido no botão
      child: Text(text),
    );
  }
}
