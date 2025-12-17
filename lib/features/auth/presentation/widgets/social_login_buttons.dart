import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Botão circular reutilizável para login social.
///
/// Suporta ícones do Material (`IconData`) ou imagens (PNG/JPG/SVG)
/// a partir de assets.
///
/// Normalmente utilizado para login com Google, Facebook, Apple, etc.
class SocialLoginButton extends StatelessWidget {
  /// Caminho do asset da imagem do botão.
  ///
  /// Pode ser uma imagem comum (PNG/JPG) ou SVG.
  /// Obrigatório caso [icon] não seja informado.
  final String? assetPath;

  /// Ícone do Material Icons a ser exibido no botão.
  ///
  /// Obrigatório caso [assetPath] não seja informado.
  final IconData? icon;

  /// Cor de fundo do botão.
  ///
  /// Por padrão é branco.
  final Color backgroundColor;

  /// Callback executado quando o botão é pressionado.
  final VoidCallback onTap;

  /// Cria um botão de login social.
  ///
  /// É obrigatório informar **um** dos seguintes:
  /// - [assetPath] para imagens (SVG, PNG, JPG)
  /// - [icon] para ícones do Material
  ///
  /// Caso nenhum seja informado, uma exceção será lançada em tempo de execução.
  const SocialLoginButton({
    super.key,
    this.assetPath,
    this.icon,
    this.backgroundColor = Colors.white,
    required this.onTap,
  }) : assert(
          assetPath != null || icon != null,
          'Either assetPath or icon must be provided',
        );

  @override
  Widget build(BuildContext context) {
    return Material(
      /// Define a cor de fundo e o formato circular do botão
      color: backgroundColor,
      shape: const CircleBorder(),
      elevation: 2,

      /// InkWell fornece feedback visual ao toque
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          padding: const EdgeInsets.all(12),
          child: _buildIcon(),
        ),
      ),
    );
  }

  /// Constrói o ícone exibido dentro do botão.
  ///
  /// A prioridade segue a ordem:
  /// 1. [icon] (Material Icon)
  /// 2. [assetPath] SVG
  /// 3. [assetPath] imagem comum (PNG/JPG)
  Widget _buildIcon() {
    /// Caso um ícone do Material seja fornecido
    if (icon != null) {
      return Icon(
        icon,
        size: 32,
        color: Colors.white,
      );
    }

    /// Caso o asset seja um SVG
    if (assetPath!.endsWith('.svg')) {
      return SvgPicture.asset(
        assetPath!,
        width: 32,
        height: 32,
      );
    }

    /// Caso o asset seja uma imagem comum
    return Image.asset(
      assetPath!,
      width: 32,
      height: 32,
    );
  }
}
