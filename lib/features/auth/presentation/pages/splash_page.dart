import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tela de Splash da aplicação.
///
/// Responsável por:
/// - Exibir a identidade visual inicial do app
/// - Executar animações de entrada (fade + scale)
/// - Exibir o app por um tempo mínimo
/// - Redirecionar para o AppShell
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

/// Estado da [SplashPage].
///
/// Utiliza [SingleTickerProviderStateMixin] para controlar
/// animações com um único [AnimationController].
class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  /// Controlador principal das animações
  late AnimationController _controller;

  /// Animação de opacidade (fade-in)
  late Animation<double> _fadeAnimation;

  /// Animação de escala (zoom suave)
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initialize();
  }

  /// Configura e inicia as animações da Splash Screen.
  ///
  /// - Fade: de 0.0 → 1.0
  /// - Scale: de 0.8 → 1.0 com efeito "easeOutBack"
  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();
  }

  /// Inicializa a Splash Screen.
  ///
  /// Executa simultaneamente:
  /// - Um delay mínimo para exibição da splash
  /// - A verificação do estado de autenticação
  ///
  /// Após a conclusão, redireciona o usuário
  /// para a rota correta.
  Future<void> _initialize() async {
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    Get.offAllNamed('/app');
  }

  @override
  void dispose() {
    /// Libera o controlador de animação
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        /// Fundo com gradiente
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0057FF),
              Color(0xFF4779DD),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Ícone principal do app
                  const Icon(
                    Icons.search_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),

                  /// Nome do aplicativo
                  Text(
                    "Busquei",
                    style: GoogleFonts.inter(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// Indicador de carregamento
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation(
                        Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
