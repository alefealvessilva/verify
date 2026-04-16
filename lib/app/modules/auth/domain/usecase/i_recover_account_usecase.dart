import 'package:result_dart/result_dart.dart';
import 'package:verify/app/modules/auth/domain/errors/auth_error.dart';
import 'package:verify/app/modules/auth/domain/repositories/i_auth_repository.dart';

abstract class IRecoverAccountUseCase {
  Future<ResultDart<Unit, AuthError>> call({required String email});
}

class RecoverAccountUseCaseImpl implements IRecoverAccountUseCase {
  final IAuthRepository _authRepository;
  RecoverAccountUseCaseImpl(this._authRepository);
  @override
  Future<ResultDart<Unit, AuthError>> call({required String email}) async {
    return await _authRepository.sendRecoverInstructions(email: email);
  }
}
