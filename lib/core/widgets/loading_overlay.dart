import 'package:flutter/material.dart';

/// Widget responsável por exibir um overlay de carregamento
/// sobre qualquer conteúdo da tela.
///
/// O [LoadingOverlay] é usado para bloquear a interação do usuário
/// enquanto uma operação assíncrona está em andamento, como:
/// - Login
/// - Cadastro
/// - Requisições à API
///
/// Ele sobrepõe o conteúdo com:
/// - Um fundo semitransparente
/// - Um indicador de carregamento (spinner)
/// - Uma mensagem opcional
///
/// Uso comum:
/// ```dart
/// LoadingOverlay(
///   isLoading: controller.isLoading.value,
///   message: 'Carregando...',
///   child: MinhaTela(),
/// )
/// ```
class LoadingOverlay extends StatelessWidget {
  /// Indica se o overlay deve ser exibido.
  ///
  /// Quando `true`, o conteúdo é bloqueado e o loader aparece.
  final bool isLoading;

  /// Conteúdo principal da tela.
  ///
  /// Esse widget ficará "por baixo" do overlay.
  final Widget child;

  /// Mensagem opcional exibida abaixo do indicador de carregamento.
  ///
  /// Útil para informar o usuário sobre o que está acontecendo,
  /// como "Entrando...", "Criando conta...", etc.
  final String? message;

  /// Cria uma instância de [LoadingOverlay].
  ///
  /// - [isLoading] controla a visibilidade do overlay
  /// - [child] é o conteúdo principal da tela
  /// - [message] é opcional
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Conteúdo principal da tela
        child,

        /// Overlay de carregamento
        if (isLoading)
          Container(
            /// Fundo escuro semitransparente
            color: Colors.black.withOpacity(0.5),

            /// Centraliza o conteúdo do loader
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),

                  /// Conteúdo do overlay
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Indicador de carregamento
                      const CircularProgressIndicator(),

                      /// Mensagem opcional
                      if (message != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          message!,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
