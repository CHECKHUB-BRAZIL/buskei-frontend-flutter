import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:buskei/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:buskei/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:buskei/features/auth/presentation/controllers/auth_controller.dart';
import 'package:buskei/features/auth/domain/usecases/login_usecase.dart';
import 'package:buskei/features/auth/domain/usecases/register_usecase.dart';
import 'package:buskei/features/auth/presentation/pages/login_page.dart';
import 'package:buskei/features/auth/presentation/pages/register_page.dart';
import 'package:buskei/features/auth/presentation/pages/splash_page.dart';


void main() {
  final datasource = AuthRemoteDataSource("http://localhost:8000");
  final repository = AuthRepositoryImpl(datasource);
  final loginUseCase = LoginUseCase(repository);
  final registerUseCase = RegisterUseCase(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => const SplashPage(),
        "/login": (context) => const LoginPage(),
        "/register": (context) => const RegisterPage(),
      },
      initialRoute: "/",
    );
  }
}
