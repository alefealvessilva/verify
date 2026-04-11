import 'package:flutter/material.dart';
import 'package:pix_sicoob/pix_sicoob.dart';
import 'package:verify/app/shared/error_registrator/register_log.dart';
import 'package:verify/app/shared/error_registrator/send_logs_to_web.dart';
import 'package:verify/app/shared/services/pix_services/models/verify_pix_model.dart';
import 'package:verify/app/shared/services/pix_services/sicoob_pix_api_service/error_handler/sicoob_pix_api_error_handler.dart';
import 'package:verify/app/shared/extensions/date_time.dart';

abstract class SicoobPixApiService {
  Future<String?> validateCredentials({
    required String clientID,
    required String certificateBase64String,
    required String certificatePassword,
  });
  Future<List<VerifyPixModel>> fetchTransactions({
    required String clientID,
    required String certificateBase64String,
    required String certificatePassword,
    DateTimeRange? dateTimeRange,
  });
}

class SicoobPixApiServiceImpl implements SicoobPixApiService {
  final SicoobPixApiServiceErrorHandler _apiServiceErrorHandler;
  final SendLogsToWeb _sendLogsToWeb;
  final RegisterLog _registerLog;

  SicoobPixApiServiceImpl(
    this._apiServiceErrorHandler,
    this._sendLogsToWeb,
    this._registerLog,
  );

  @override
  Future<String?> validateCredentials({
    required String clientID,
    required String certificateBase64String,
    required String certificatePassword,
  }) async {
    try {
      final pixSicoob = PixSicoob(
        clientID: clientID,
        certificateBase64String: certificateBase64String,
        certificatePassword: certificatePassword,
      );
      final tokenResult = await pixSicoob.getToken();

      return tokenResult.fold(
        (token) async {
          final txResult = await pixSicoob.fetchTransactions(token: token);
          return txResult.fold(
            (success) => null,
            (failure) async {
              final errorMsg = await _apiServiceErrorHandler(failure);
              _sendLogsToWeb('Sicoob Validation Failure: $errorMsg');
              return errorMsg;
            },
          );
        },
        (failure) async {
          final errorMsg = await _apiServiceErrorHandler(failure);
          _sendLogsToWeb('Sicoob Token Failure: $errorMsg');
          return errorMsg;
        },
      );
    } catch (e) {
      _sendLogsToWeb('Sicoob Credential Fatal: $e');
      _registerLog(e);
      return 'Não foi possível validar as credenciais. Verifique os dados e tente novamente.';
    }
  }

  @override
  Future<List<VerifyPixModel>> fetchTransactions({
    required String clientID,
    required String certificateBase64String,
    required String certificatePassword,
    DateTimeRange? dateTimeRange,
  }) async {
    try {
      final pixSicoob = PixSicoob(
        clientID: clientID,
        certificateBase64String: certificateBase64String,
        certificatePassword: certificatePassword,
      );

      final tokenResult = await pixSicoob.getToken();

      return await tokenResult.fold(
        (token) async {
          // Se o range cruzar o mês, fazemos Smart Chunking por mês
          if (dateTimeRange != null &&
              dateTimeRange.start.month != dateTimeRange.end.month) {
            return await _fetchWithMonthlyChunking(
              pixSicoob: pixSicoob,
              token: token,
              clientID: clientID,
              dateTimeRange: dateTimeRange,
            );
          }

          final transactionsResult = await pixSicoob.fetchTransactions(
            token: token,
            dateTimeRange: dateTimeRange,
          );

          return transactionsResult.fold(
            (transactions) {
              final verifyTransactions = transactions
                  .map((pix) => VerifyPixModel(
                        clientName: pix.pagador.nome,
                        documment: pix.pagador.cpf ?? pix.pagador.cnpj,
                        value: double.parse(pix.valor),
                        date: DateTime.parse(pix.horario).toBrazilianTimeZone(),
                      ))
                  .toList();

              double currentTotal =
                  verifyTransactions.fold(0, (sum, item) => sum + item.value);
              debugPrint(
                  'Sicoob Simple Fetch: ${verifyTransactions.length} transações. Total parcial: R\$ $currentTotal');

              return verifyTransactions;
            },
            (failure) {
              _sendLogsToWeb('Sicoob Transactions Failure: $failure');
              _registerLog(failure);
              return <VerifyPixModel>[];
            },
          );
        },
        (failure) {
          _sendLogsToWeb('Sicoob Token Fetch Failure: $failure');
          _registerLog(failure);
          return <VerifyPixModel>[];
        },
      );
    } catch (e) {
      _sendLogsToWeb('Sicoob Fetch Fatal: $e');
      _registerLog(e);
      return <VerifyPixModel>[];
    }
  }

  /// Resolve a trava 'date-range-must-be-in-the-same-month' fatiando o pedido por mês
  Future<List<VerifyPixModel>> _fetchWithMonthlyChunking({
    required PixSicoob pixSicoob,
    required Token token,
    required String clientID,
    required DateTimeRange dateTimeRange,
  }) async {
    List<VerifyPixModel> allTransactions = [];
    DateTime currentStart = dateTimeRange.start;

    while (currentStart.isBefore(dateTimeRange.end)) {
      // O fim do chunk é o último segundo do mês atual do currentStart
      // ou o fim do dateTimeRange original
      DateTime lastDayOfMonth =
          DateTime(currentStart.year, currentStart.month + 1, 0, 23, 59, 59);
      DateTime currentEnd = lastDayOfMonth.isBefore(dateTimeRange.end)
          ? lastDayOfMonth
          : dateTimeRange.end;

      final chunkRange = DateTimeRange(start: currentStart, end: currentEnd);

      final result = await pixSicoob.fetchTransactions(
        token: token,
        dateTimeRange: chunkRange,
      );

      result.fold(
        (transactions) {
          final chunkTransactions = transactions
              .map((pix) => VerifyPixModel(
                    clientName: pix.pagador.nome,
                    documment: pix.pagador.cpf ?? pix.pagador.cnpj,
                    value: double.parse(pix.valor),
                    date: DateTime.parse(pix.horario).toBrazilianTimeZone(),
                  ))
              .toList();

          double chunkTotal =
              chunkTransactions.fold(0, (sum, item) => sum + item.value);
          debugPrint(
              'Sicoob Chunk: ${chunkTransactions.length} transações. Total parcial: R\$ $chunkTotal');

          allTransactions.addAll(chunkTransactions);
        },
        (failure) {
          _sendLogsToWeb(
              'Sicoob Chunk Failure ($currentStart to $currentEnd): $failure');
          _registerLog(failure);
        },
      );

      // Avança para o dia 1 do próximo mês
      currentStart =
          DateTime(currentStart.year, currentStart.month + 1, 1, 0, 0, 0);
    }

    allTransactions.sort((a, b) => b.date.compareTo(a.date));
    return allTransactions;
  }
}
