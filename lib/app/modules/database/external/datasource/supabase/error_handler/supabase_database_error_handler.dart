import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verify/app/shared/error_registrator/register_log.dart';
import 'package:verify/app/shared/error_registrator/send_logs_to_web.dart';

class SupabaseDatabaseErrorHandler {
  final RegisterLog _registerLog;
  final SendLogsToWeb _sendLogsToWeb;

  SupabaseDatabaseErrorHandler(
    this._registerLog,
    this._sendLogsToWeb,
  );

  Future<String> call(Object e) async {
    String errorMessage =
        'Ocorreu um erro ao processar a solicitação no banco de dados.';
    String errorCode = 'unknown';

    if (e is PostgrestException) {
      errorCode = e.code ?? 'unknown';
      errorMessage = e.message;

      // Basic mapping for common errors
      if (errorCode == 'PGRST116') {
        errorMessage = 'Nenhum registro encontrado.';
      } else if (errorCode.startsWith('23')) {
        errorMessage = 'Erro de restrição de dados (ex: chave duplicada).';
      }
    } else {
      await _sendLogsToWeb(e);
    }

    final dbError =
        'SupabaseDatabaseError: code: $errorCode Message: ${e.toString()}';
    _registerLog(dbError);

    return errorMessage;
  }
}
