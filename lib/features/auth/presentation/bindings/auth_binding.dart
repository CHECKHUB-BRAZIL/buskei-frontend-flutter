import 'package:buskei/features/auth/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/config/api_config.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Storage
    final storage = const FlutterSecureStorage();
    Get.put<FlutterSecureStorage>(storage, permanent: true);

    // ApiClient
    Get.put<ApiClient>(
      ApiClient(
        baseUrl: ApiConfig.baseUrl,
        storage: storage,
      ),
      permanent: true,
    );

    // Datasources
    Get.put<AuthRemoteDataSource>(
      AuthRemoteDataSourceImpl(
        apiClient: Get.find<ApiClient>(),
      ),
    );

    Get.put<AuthLocalDataSource>(
      AuthLocalDataSourceImpl(storage: Get.find()),
    );

    // Repository
    Get.put<AuthRepository>(
      AuthRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
        connectivity: Connectivity(),
      ),
    );

    // Use cases
    Get.put<LoginUseCase>(
      LoginUseCase(Get.find()),
    );

    Get.put<RegisterUseCase>(
      RegisterUseCase(Get.find()),
    );

    Get.put<LogoutUseCase>(
      LogoutUseCase(Get.find()),
    );

    Get.put<GetCurrentUserUseCase>(
      GetCurrentUserUseCase(Get.find()),
    );

    // Controller
    Get.put<AuthController>(
      AuthController(
        loginUseCase: Get.find(),
        registerUseCase: Get.find(),
        logoutUseCase: Get.find(),
        getCurrentUserUseCase: Get.find(),
      ),
    );
  }
}
