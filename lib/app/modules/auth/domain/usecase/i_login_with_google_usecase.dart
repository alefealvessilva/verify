import 'package:result_dart/result_dart.dart';
import 'package:verify/app/modules/auth/domain/entities/logged_user_info.dart';
import 'package:verify/app/modules/auth/domain/errors/auth_error.dart';
import 'package:verify/app/modules/auth/domain/repositories/i_auth_repository.dart';

abstract class ILoginWithGoogleUseCase {
  Future<ResultDart<LoggedUserInfoEntity, AuthError>> call();
}

class LoginWithGoogleImpl implements ILoginWithGoogleUseCase {
  final IAuthRepository _authRepository;
  LoginWithGoogleImpl(this._authRepository);

  @override
  Future<ResultDart<LoggedUserInfoEntity, AuthError>> call() async {
    return _authRepository.loginWithGoogle();
  }
}
