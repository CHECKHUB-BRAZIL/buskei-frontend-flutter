import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes.dart';
import 'theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      /// Título da aplicação
      title: 'Busquei',

      /// Remove o banner de debug
      debugShowCheckedModeBanner: false,

      // ---------------------------------------------------------------------
      // Tema
      // ---------------------------------------------------------------------

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // ---------------------------------------------------------------------
      // Navegação
      // ---------------------------------------------------------------------

      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,

      // ❌ NÃO TEM initialBinding
      // ❌ NÃO TEM injection_container
      // ❌ NÃO TEM GetIt

      // ---------------------------------------------------------------------
      // Internacionalização
      // ---------------------------------------------------------------------

      locale: const Locale('pt', 'BR'),
      fallbackLocale: const Locale('en', 'US'),

      // ---------------------------------------------------------------------
      // Transições
      // ---------------------------------------------------------------------

      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
