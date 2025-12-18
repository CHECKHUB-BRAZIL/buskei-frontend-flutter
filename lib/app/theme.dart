import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Classe responsável por centralizar toda a configuração de tema da aplicação.
///
/// Benefícios:
/// - Consistência visual em todo o app
/// - Facilidade de manutenção e evolução do design
/// - Evita repetição de estilos nos widgets
///
/// Suporta:
/// - Tema claro (lightTheme)
/// - Tema escuro (darkTheme)
class AppTheme {
  // ---------------------------------------------------------------------------
  // Paleta de cores principal da aplicação
  // ---------------------------------------------------------------------------

  /// Cor primária da marca
  static const Color primaryColor = Color(0xFF0057FF);

  /// Cor secundária (apoio visual)
  static const Color secondaryColor = Color(0xFF4779DD);

  /// Cor padrão para erros
  static const Color errorColor = Color(0xFFE53935);

  /// Cor padrão para estados de sucesso
  static const Color successColor = Color(0xFF43A047);

  // ---------------------------------------------------------------------------
  // Tema claro
  // ---------------------------------------------------------------------------

  /// Tema utilizado quando o app está em modo claro.
  ///
  /// Configura:
  /// - Material 3
  /// - Esquema de cores baseado na cor primária
  /// - Tipografia padrão (Inter)
  /// - Estilos globais de AppBar, botões, inputs e cards
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // -----------------------------------------------------------------------
      // Esquema de cores
      // -----------------------------------------------------------------------
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        error: errorColor,
      ),

      // -----------------------------------------------------------------------
      // Tipografia global
      // -----------------------------------------------------------------------
      textTheme: GoogleFonts.interTextTheme(),

      // -----------------------------------------------------------------------
      // AppBar
      // -----------------------------------------------------------------------
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),

      // -----------------------------------------------------------------------
      // Botões elevados (ElevatedButton)
      // -----------------------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // -----------------------------------------------------------------------
      // Inputs (TextField / TextFormField)
      // -----------------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: errorColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),

      // -----------------------------------------------------------------------
      // Cards
      // -----------------------------------------------------------------------
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tema escuro
  // ---------------------------------------------------------------------------

  /// Tema utilizado quando o app está em modo escuro.
  ///
  /// Atualmente define:
  /// - Material 3
  /// - Esquema de cores escuro
  /// - Tipografia Inter adaptada ao tema dark
  ///
  /// Pode ser expandido futuramente com:
  /// - AppBarTheme específico
  /// - Botões personalizados
  /// - Cores de fundo e superfícies
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        error: errorColor,
      ),

      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ),

      // TODO: Adicionar customizações específicas do tema escuro
    );
  }
}
