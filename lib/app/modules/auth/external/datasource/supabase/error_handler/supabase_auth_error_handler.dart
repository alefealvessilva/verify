import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verify/app/shared/error_registrator/i_register_log.dart';
import 'package:verify/app/shared/error_registrator/i_send_logs_to_web.dart';

enum SupabaseAuthErrorType {
  invalidCredentials(
    errorCode: 'invalid login credentials',
    message: 'Credenciais de login inválidas. Verifique seu email e senha.',
  ),
  invalidCredentialsAlt(
    errorCode: 'invalid_credentials',
    message: 'O email ou a senha estão incorretos.',
  ),
  userNotFound(
    errorCode: 'user not found',
    message: 'Usuário não encontrado. Revise suas informações.',
  ),
  userNotFoundAlt(
    errorCode: 'user_not_found',
    message: 'Usuário não encontrado. Revise suas informações.',
  ),
  emailAlreadyInUse(
    errorCode: 'user already registered',
    message: 'Este usuário já está cadastrado.',
  ),
  emailAlreadyInUseAlt(
    errorCode: 'user_already_exists',
    message: 'Este usuário já está cadastrado.',
  ),
  weakPassword(
    errorCode: 'weak_password',
    message: 'A senha fornecida é muito fraca.',
  ),
  weakPasswordAlt(
    errorCode: 'password should be at least',
    message: 'A senha fornecida é muito fraca ou curta.',
  ),
  emailNotConfirmed(
    errorCode: 'email not confirmed',
    message: 'Seu email ainda não foi confirmado.',
  ),
  invalidLink(
    errorCode: 'email link is invalid or has expired',
    message: 'O link do email é inválido ou expirou.',
  ),
  invalidToken(
    errorCode: 'token has expired or is invalid',
    message: 'O token de segurança é inválido ou expirou.',
  ),
  samePassword(
    errorCode: 'new password should be different',
    message: 'A nova senha deve ser diferente da senha antiga.',
  ),
  rateLimit(
    errorCode: 'rate limit exceeded',
    message: 'Muitas tentativas em pouco tempo. Tente novamente mais tarde.',
  ),
  rateLimitAlt(
    errorCode: 'too many requests',
    message: 'Muitas requisições. Tente novamente mais tarde.',
  ),
  unknown(
    errorCode: 'unknown',
    message:
        'Ocorreu um erro ao realizar a solicitação, tente novamente mais tarde.',
  );

  const SupabaseAuthErrorType({
    required this.errorCode,
    required this.message,
  });

  final String message;
  final String errorCode;
}

class SupabaseAuthErrorHandler {
  final IRegisterLog _registerLog;
  final ISendLogsToWeb _sendLogsToWeb;

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
