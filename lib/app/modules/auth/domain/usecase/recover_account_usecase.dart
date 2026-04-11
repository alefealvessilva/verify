import 'package:result_dart/result_dart.dart';
import 'package:verify/app/modules/auth/domain/errors/auth_error.dart';
import 'package:verify/app/modules/auth/domain/repositories/auth_repository.dart';

abstract class RecoverAccountUseCase {
  Future<ResultDart<Unit, AuthError>> call({required String email});
}

class RecoverAccountUseCaseImpl implements RecoverAccountUseCase {
  final AuthRepository _authRepository;
  RecoverAccountUseCaseImpl(this._authRepository);
  @override
  Future<ResultDart<Unit, AuthError>> call({required String email}) async {
    return await _authRepository.sendRecoverInstructions(email: email);
  }
}
