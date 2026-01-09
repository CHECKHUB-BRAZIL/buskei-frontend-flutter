import 'package:get/get.dart';
import '../controllers/app_shell_controller.dart';

class AppShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AppShellController>(AppShellController());
  }
}
