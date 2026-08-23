import 'package:result_dart/result_dart.dart';
import 'package:verify/app/modules/auth/domain/errors/auth_error.dart';
import 'package:verify/app/modules/auth/domain/repositories/i_auth_repository.dart';

abstract class IUpdatePasswordUseCase {
  Future<ResultDart<Unit, AuthError>> call({required String newPassword});
}

class UpdatePasswordUseCaseImpl implements IUpdatePasswordUseCase {
  final IAuthRepository _authRepository;
  UpdatePasswordUseCaseImpl(this._authRepository);

  @override
  Future<ResultDart<Unit, AuthError>> call({required String newPassword}) async {
    return await _authRepository.updatePassword(newPassword: newPassword);
  }
}
