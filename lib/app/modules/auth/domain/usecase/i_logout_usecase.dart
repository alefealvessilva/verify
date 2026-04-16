import 'package:result_dart/result_dart.dart';
import 'package:verify/app/modules/auth/domain/errors/auth_error.dart';
import 'package:verify/app/modules/auth/domain/repositories/i_auth_repository.dart';

abstract class ILogoutUseCase {
  Future<ResultDart<Unit, AuthError>> call();
}

class LogoutUseCaseImpl implements ILogoutUseCase {
  final IAuthRepository _authRepository;

  LogoutUseCaseImpl(this._authRepository);
  @override
  Future<ResultDart<Unit, AuthError>> call() async {
    return await _authRepository.logout();
  }
}
