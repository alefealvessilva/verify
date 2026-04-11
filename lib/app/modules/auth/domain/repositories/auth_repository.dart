import 'package:result_dart/result_dart.dart';
import 'package:verify/app/modules/auth/domain/entities/logged_user_info.dart';
import 'package:verify/app/modules/auth/domain/errors/auth_error.dart';

abstract class AuthRepository {
  Future<ResultDart<LoggedUserInfoEntity, AuthError>> registerWithEmail({
    required String email,
    required String password,
  });

  Future<ResultDart<LoggedUserInfoEntity, AuthError>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<ResultDart<LoggedUserInfoEntity, AuthError>> loginWithGoogle();
  Future<ResultDart<Unit, AuthError>> logout();
  Future<LoggedUserInfoEntity?> loggedUser();
  Future<ResultDart<Unit, AuthError>> sendRecoverInstructions({
    required String email,
  });
}
