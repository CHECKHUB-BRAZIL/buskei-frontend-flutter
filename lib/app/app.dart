import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/auth/presentation/controllers/auth_controller.dart';
import '../injection_container.dart';
import 'routes.dart';
import 'theme.dart';

/// Widget raiz da aplicação.
///
/// Responsável por:
/// - Configurar o tema (claro e escuro)
/// - Definir o sistema de rotas
/// - Inicializar dependências globais
/// - Configurar internacionalização
/// - Definir transições de navegação
///
/// Utiliza o [GetMaterialApp] para:
/// - Gerenciamento de estado com GetX
/// - Injeção de dependências
/// - Navegação simplificada
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      /// Título da aplicação (usado pelo sistema operacional)
      title: 'Busquei',

      /// Remove o banner de debug
      debugShowCheckedModeBanner: false,

      // ---------------------------------------------------------------------
      // Tema da aplicação
      // ---------------------------------------------------------------------

      /// Tema claro
      theme: AppTheme.lightTheme,

      /// Tema escuro
      darkTheme: AppTheme.darkTheme,

      /// Modo de tema (fixo em claro por enquanto)
      themeMode: ThemeMode.light,

      // ---------------------------------------------------------------------
      // Navegação e rotas
      // ---------------------------------------------------------------------

      /// Rota inicial da aplicação
      initialRoute: AppRoutes.splash,

      /// Lista de rotas registradas no GetX
      getPages: AppRoutes.routes,

      // ---------------------------------------------------------------------
      // Injeção de dependências global
      // ---------------------------------------------------------------------

      /// Binding inicial da aplicação.
      ///
      /// Injeta o [AuthController] globalmente,
      /// permitindo que ele seja acessado em qualquer parte do app.
      ///
      /// A instância é resolvida via Service Locator (GetIt).
      initialBinding: BindingsBuilder(() {
        Get.put<AuthController>(sl<AuthController>());
      }),

      // ---------------------------------------------------------------------
      // Internacionalização (i18n)
      // ---------------------------------------------------------------------

      /// Localização padrão da aplicação
      locale: const Locale('pt', 'BR'),

      /// Localização de fallback caso a atual não esteja disponível
      fallbackLocale: const Locale('en', 'US'),

      // ---------------------------------------------------------------------
      // Transições de navegação
      // ---------------------------------------------------------------------

      /// Transição padrão entre telas
      defaultTransition: Transition.fadeIn,

      /// Duração da transição entre páginas
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
