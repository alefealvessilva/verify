import 'package:flutter/material.dart';
import 'package:pix_bb/pix_bb.dart';
import 'package:verify/app/shared/error_registrator/register_log.dart';
import 'package:verify/app/shared/error_registrator/send_logs_to_web.dart';
import 'package:verify/app/shared/services/pix_services/bb_pix_api_service/error_handler/bb_pix_api_error_handler.dart';
import 'package:verify/app/shared/services/pix_services/models/verify_pix_model.dart';
import 'package:verify/app/shared/extensions/date_time.dart';

abstract class BBPixApiService {
  Future<String?> validateCredentials({
    required String applicationDeveloperKey,
    required String basicKey,
  });
  Future<List<VerifyPixModel>> fetchTransactions({
    required String applicationDeveloperKey,
    required String basicKey,
    DateTimeRange? dateTimeRange,
  });
}

class BBPixApiServiceImpl implements BBPixApiService {
  final SendLogsToWeb _sendLogsToWeb;
  final RegisterLog _registerLog;
  final BBPixApiServiceErrorHandler _apiServiceErrorHandler;

  BBPixApiServiceImpl(
    this._sendLogsToWeb,
    this._registerLog,
    this._apiServiceErrorHandler,
  );

  @override
  Future<String?> validateCredentials({
    required String applicationDeveloperKey,
    required String basicKey,
  }) async {
    try {
      final pixBB = PixBB(
        ambiente: Ambiente.producao,
        basicKey: "Basic $basicKey",
        developerApplicationKey: applicationDeveloperKey,
      );
      final token = await pixBB.getToken();
      await pixBB.fetchTransactions(token: token);
      return null;
    } on PixException catch (e) {
      final errorMessage = await _apiServiceErrorHandler(e);
      _sendLogsToWeb('BB Validation Failure: $errorMessage');
      return errorMessage;
    } catch (e) {
      await _sendLogsToWeb(e);
      _registerLog(e);
      return 'Não foi possível validar as credenciais. Tente novamente.';
    }
  }

  @override
  Future<List<VerifyPixModel>> fetchTransactions({
    required String applicationDeveloperKey,
    required String basicKey,
    DateTimeRange? dateTimeRange,
  }) async {
    try {
      final pixBB = PixBB(
        ambiente: Ambiente.producao,
        basicKey: "Basic $basicKey",
        developerApplicationKey: applicationDeveloperKey,
      );

      final token = await pixBB.getToken();

      // Se não houver range ou o intervalo for curto, faz chamada única
      // Reduzido para 4 dias para garantir aceitação da lib pix_bb
      if (dateTimeRange == null || dateTimeRange.duration.inDays < 4) {
        return await _fetchWithToken(
          pixBB: pixBB,
          token: token,
          dateTimeRange: dateTimeRange,
        );
      }

      // Lógica de Smart Chunking (4 dias)
      List<VerifyPixModel> allTransactions = [];
      DateTime currentStart = dateTimeRange.start;

      while (currentStart.isBefore(dateTimeRange.end)) {
        DateTime currentEnd = currentStart.add(const Duration(days: 4));
        if (currentEnd.isAfter(dateTimeRange.end)) {
          currentEnd = dateTimeRange.end;
        }

        final chunkRange = DateTimeRange(start: currentStart, end: currentEnd);

        try {
          final chunk = await _fetchWithToken(
            pixBB: pixBB,
            token: token,
            dateTimeRange: chunkRange,
          );
          allTransactions.addAll(chunk);
        } catch (e) {
          _sendLogsToWeb('Erro no bloco BB: $currentStart a $currentEnd - $e');
          _registerLog('Erro no bloco BB: $currentStart a $currentEnd - $e');
        }

        currentStart = currentEnd.add(const Duration(seconds: 1));
        if (currentStart.isAfter(dateTimeRange.end)) break;
      }

      allTransactions.sort((a, b) => b.date.compareTo(a.date));
      final seen = <String>{};
      return allTransactions.where((t) {
        final key =
            '${t.clientName}_${t.value}_${t.date.millisecondsSinceEpoch}';
        return seen.add(key);
      }).toList();
    } on PixException catch (e) {
      final errorMessage = await _apiServiceErrorHandler(e);
      _sendLogsToWeb('BB Pix Error: $errorMessage');
      rethrow;
    } catch (e) {
      _sendLogsToWeb('BB Pix Fatal: $e');
      _registerLog(e);
      rethrow;
    }
  }

  Future<List<VerifyPixModel>> _fetchWithToken({
    required PixBB pixBB,
    required Token token,
    DateTimeRange? dateTimeRange,
  }) async {
    final transactions = await pixBB.fetchTransactions(
      token: token,
      dateTimeRange: dateTimeRange,
    );

    final verifyTransactions = transactions
        .map((pix) => VerifyPixModel(
              clientName: pix.pagador.nome,
              documment: pix.pagador.cpf ?? pix.pagador.cnpj,
              value: double.parse(pix.valor),
              date: DateTime.parse(pix.horario).toBrazilianTimeZone(),
            ))
        .toList();

    double chunkTotal =
        verifyTransactions.fold(0, (sum, item) => sum + item.value);
    debugPrint(
        'BB Fetch: ${verifyTransactions.length} transações. Total parcial: R\$ $chunkTotal');

    return verifyTransactions;
  }
}
