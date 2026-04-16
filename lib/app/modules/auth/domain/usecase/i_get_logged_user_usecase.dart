import 'package:verify/app/modules/auth/domain/entities/logged_user_info.dart';
import 'package:verify/app/modules/auth/domain/repositories/i_auth_repository.dart';

abstract class IGetLoggedUserUseCase {
  Future<LoggedUserInfoEntity?> call();
}

class GetLoggedUserUseCaseImpl implements IGetLoggedUserUseCase {
  final IAuthRepository _authRepository;

  GetLoggedUserUseCaseImpl(this._authRepository);
  @override
  Future<LoggedUserInfoEntity?> call() async {
    return await _authRepository.loggedUser();
  }
}
