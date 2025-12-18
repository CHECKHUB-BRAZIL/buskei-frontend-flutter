import 'package:get/get.dart';

class HomeController extends GetxController {
  /// Índice da aba selecionada
  final currentIndex = 0.obs;

  /// Altera a aba ativa
  void changeTab(int index) {
    currentIndex.value = index;
  }
}
