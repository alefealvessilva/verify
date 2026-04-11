import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verify/app/shared/error_registrator/register_log.dart';
import 'package:verify/app/shared/error_registrator/send_logs_to_web.dart';

enum SupabaseAuthErrorType {
  invalidCredentials(
    errorCode: 'invalid_credentials',
    message: 'O email ou a senha estão incorretos',
  ),
  userNotFound(
    errorCode: 'user_not_found',
    message: 'Usuário não encontrado, revise suas informações',
  ),
  emailAlreadyInUse(
    errorCode: 'email_exists',
    message: 'Usuário já cadastrado',
  ),
  weakPassword(
    errorCode: 'weak_password',
    message: 'A senha fornecida é muito fraca',
  ),
  unknown(
    errorCode: 'unknown',
    message:
        'Ocorreu um erro ao realizar a solicitação, tente novamente mais tarde',
  );

  const SupabaseAuthErrorType({
    required this.errorCode,
    required this.message,
  });

  final String message;
  final String errorCode;
}

class SupabaseAuthErrorHandler {
  final RegisterLog _registerLog;
  final SendLogsToWeb _sendLogsToWeb;

  SupabaseAuthErrorHandler(
    this._registerLog,
    this._sendLogsToWeb,
  );

  Future<String> call(Object e) async {
    String errorMessage = SupabaseAuthErrorType.unknown.message;
    String errorCode = 'unknown';

    if (e is AuthException) {
      errorCode = e
          .message; // Supabase uses message for the error code in some contexts, or we check e.statusCode

      // Attempt to map error codes
      for (final type in SupabaseAuthErrorType.values) {
        if (e.message.toLowerCase().contains(type.errorCode.toLowerCase())) {
          errorMessage = type.message;
          errorCode = type.errorCode;
          break;
        }
      }
    } else {
      await _sendLogsToWeb(e);
    }

    final authError =
        'SupabaseAuthError: code: $errorCode Message: ${e.toString()}';
    _registerLog(authError);

    return errorMessage;
  }
}
