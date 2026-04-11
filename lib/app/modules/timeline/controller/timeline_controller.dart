import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:verify/app/core/api_credentials_store.dart';
import 'package:verify/app/modules/home/store/home_store.dart';
import 'package:verify/app/modules/timeline/store/timeline_store.dart';
import 'package:verify/app/shared/extensions/date_time.dart';
import 'package:verify/app/shared/services/pix_services/bb_pix_api_service/bb_pix_api_service.dart';
import 'package:verify/app/shared/services/pix_services/sicoob_pix_api_service/sicoob_pix_api_service.dart';

class TimelineController {
  final SicoobPixApiService _sicoobPixApiService;
  final BBPixApiService _bbPixApiService;

  final store = Modular.get<TimelineStore>();
  final apiStore = Modular.get<ApiCredentialsStore>();
  final homeStore = Modular.get<HomeStore>();

  TimelineController(
    this._sicoobPixApiService,
    this._bbPixApiService,
  ) {
    _init();
  }

  void _init() {
    // Sincroniza o banco inicial com o que está visível na Home
    _syncInitialAccount();
    goToTodayDate();
  }

  void _syncInitialAccount() {
    // Se isSicoobActive na Home for true, index 0, senão 1
    final sicoobActive = homeStore.isSicoobActive;
    store.setSelectedAccountIndex(sicoobActive ? 0 : 1);
  }

  void selectAccount(int index) {
    store.setSelectedAccountIndex(index);
    fetchTransactions();
  }

  void updateDateRange(DateTimeRange range) {
    final start = DateTime(range.start.year, range.start.month, range.start.day, 0, 0, 0);
    final end = DateTime(range.end.year, range.end.month, range.end.day, 23, 59, 59);
    
    store.setSelectedDateRange(DateTimeRange(start: start, end: end));
    fetchTransactions();
  }

  void goToTodayDate() {
    final now = DateTime.now().toBrazilianTimeZone();
    final today = DateTimeRange(
      start: DateTime(now.year, now.month, now.day, 0, 0, 0),
      end: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
    store.setSelectedDateRange(today);
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      store.setIsLoadingTransactions(true);
      final range = store.selectedDateRange;
      final isSicoob = store.selectedAccountIndex == 0;

      if (isSicoob) {
        if (apiStore.sicoobApiCredentialsEntity != null) {
          final credentials = apiStore.sicoobApiCredentialsEntity!;
          final result = await _sicoobPixApiService.fetchTransactions(
            dateTimeRange: range,
            clientID: credentials.clientID,
            certificateBase64String: credentials.certificateBase64String,
            certificatePassword: credentials.certificatePassword,
          );
          store.setTransactions(result);
        } else {
          store.setTransactions([]);
        }
      } else {
        if (apiStore.bbApiCredentialsEntity != null) {
          final credentials = apiStore.bbApiCredentialsEntity!;
          final result = await _bbPixApiService.fetchTransactions(
            dateTimeRange: range,
            applicationDeveloperKey: credentials.applicationDeveloperKey,
            basicKey: credentials.basicKey,
          );
          store.setTransactions(result);
        } else {
          store.setTransactions([]);
        }
      }
    } catch (e) {
      debugPrint('Error fetching timeline transactions: $e');
      store.setTransactions([]);
    } finally {
      store.setIsLoadingTransactions(false);
    }
  }
}
