import 'package:result_dart/result_dart.dart';
import 'package:verify/app/modules/auth/domain/entities/logged_user_info.dart';
import 'package:verify/app/modules/auth/domain/entities/login_credentials_entity.dart';
import 'package:verify/app/modules/auth/domain/errors/auth_error.dart';
import 'package:verify/app/modules/auth/domain/repositories/i_auth_repository.dart';

abstract class ILoginWithEmailUseCase {
  Future<ResultDart<LoggedUserInfoEntity, AuthError>> call({
    required String email,
    required String password,
  });
}

class LoginWithEmailUseCaseImpl implements ILoginWithEmailUseCase {
  final IAuthRepository _authRepository;
  LoginWithEmailUseCaseImpl(this._authRepository);

  @override
  Future<ResultDart<LoggedUserInfoEntity, AuthError>> call({
    required String email,
    required String password,
  }) async {
    final loginCredentialsEntity = LoginCredentialsEntity(email: email, password: password);
    
    if (!loginCredentialsEntity.isValidEmail) {
      return Failure(ErrorLoginEmail(message: 'invalid-email'));
    } else if (!loginCredentialsEntity.isValidPassword) {
      return Failure(ErrorLoginEmail(message: 'invalid-password'));
    }

    final result = await _authRepository.loginWithEmail(
      email: loginCredentialsEntity.email,
      password: loginCredentialsEntity.password,
    );
    return result;
  }
}
