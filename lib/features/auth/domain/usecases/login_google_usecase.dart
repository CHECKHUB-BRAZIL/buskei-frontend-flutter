import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import '../usecases/usecase.dart';
import '../../../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';

class LoginWithGoogleUseCase
    implements UseCase<UserEntity, LoginWithGoogleParams> {
  final AuthRepository repository;

  LoginWithGoogleUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(
    LoginWithGoogleParams params,
  ) async {
    return await repository.loginWithGoogle(
      idToken: params.idToken,
    );
  }
}

class LoginWithGoogleParams {
  final String idToken;

  LoginWithGoogleParams({required this.idToken});
}
