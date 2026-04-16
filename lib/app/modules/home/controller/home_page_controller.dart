import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/app/core/api_credentials_store.dart';
import 'package:verify/app/core/auth_store.dart';
import 'package:verify/app/modules/database/domain/entities/bb_api_credentials_entity.dart';
import 'package:verify/app/modules/database/domain/entities/sicoob_api_credentials_entity.dart';
import 'package:verify/app/modules/database/domain/usecase/bb_api_credentials_usecases/update_bb_api_credentials_usecase.dart';
import 'package:verify/app/modules/database/domain/usecase/sicoob_api_credentials_usecases/update_sicoob_api_credentials_usecase.dart';
import 'package:verify/app/modules/database/utils/database_enums.dart';
import 'package:verify/app/modules/home/store/home_store.dart';
import 'package:verify/app/shared/extensions/date_time.dart';
import 'package:verify/app/shared/extensions/string.dart';
import 'package:verify/app/shared/services/pix_services/bb_pix_api_service/i_bb_pix_api_service.dart';
import 'package:verify/app/shared/services/pix_services/sicoob_pix_api_service/i_sicoob_pix_api_service.dart';

class HomePageController {
  final ISicoobPixApiService _sicoobPixApiService;
  final IBBPixApiService _bbPixApiService;
  final UpdateBBApiCredentialsUseCase _updateBBApiCredentialsUseCase;
  final UpdateSicoobApiCredentialsUseCase _updateSicoobApiCredentialsUseCase;

  final homeStore = Modular.get<HomeStore>();
  final apiStore = Modular.get<ApiCredentialsStore>();
  final authStore = Modular.get<AuthStore>();

  DateTime currentDate = DateTime.now().toBrazilianTimeZone();

  HomePageController(
    this._sicoobPixApiService,
    this._bbPixApiService,
    this._updateBBApiCredentialsUseCase,
    this._updateSicoobApiCredentialsUseCase,
  ) {
    _init();
  }

  Future<void> _init() async {
    await _loadCardOrder();
    fetchTransactions();
  }

  void refreshCurrentDate() {
    currentDate = DateTime.now().toBrazilianTimeZone();
  }

  void updateFilter(int value) {
    homeStore.setSelectedFilter(value);
    refreshCurrentDate();
    fetchTransactions();
  }

  /// Gerencia a mudança de conta (swipe ou favorito)
  /// Reseta o filtro para 'Hoje' e dispara a consulta
  void handleAccountChange(int index) {
    homeStore.setVisibleCardIndex(index);
    homeStore.setSelectedFilter(0); // Reset filter to 'Today'
    homeStore.setIsLoadingTransactions(true); // Clear old transactions immediately
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      homeStore.setIsLoadingTransactions(true);
      final isSicoob = homeStore.isSicoobActive;
      final range = _getDateTimeRange();

      if (isSicoob) {
        if (apiStore.sicoobApiCredentialsEntity != null) {
          final credentials = apiStore.sicoobApiCredentialsEntity!;
          final result = await _sicoobPixApiService.fetchTransactions(
            dateTimeRange: range,
            clientID: credentials.clientID,
            certificateBase64String: credentials.certificateBase64String,
            certificatePassword: credentials.certificatePassword,
          );
          debugPrint('HomePageController: ${result.length} transações carregadas do Sicoob.');
          homeStore.setTransactions(result);
        }
      } else {
        if (apiStore.bbApiCredentialsEntity != null) {
          final credentials = apiStore.bbApiCredentialsEntity!;
          final result = await _bbPixApiService.fetchTransactions(
            dateTimeRange: range,
            applicationDeveloperKey: credentials.applicationDeveloperKey,
            basicKey: credentials.basicKey,
          );
          debugPrint('HomePageController: ${result.length} transações carregadas do BB.');
          homeStore.setTransactions(result);
        }
      }
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      homeStore.setTransactions([]);
    } finally {
      homeStore.setIsLoadingTransactions(false);
    }
  }

  DateTimeRange _getDateTimeRange() {
    final now = DateTime.now().toBrazilianTimeZone();
    DateTime initialDate;
    DateTime endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    switch (homeStore.selectedFilter) {
      case 1: // Ontem
        final yesterday = now.subtract(const Duration(days: 1));
        initialDate = DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
        endDate = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        break;
      case 2: // Semana
        initialDate = now.subtract(const Duration(days: 6));
        initialDate = DateTime(initialDate.year, initialDate.month, initialDate.day, 0, 0, 0);
        break;
      case 0: // Hoje
      default:
        initialDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
        break;
    }
    return DateTimeRange(start: initialDate, end: endDate);
  }

  Future<void> _loadCardOrder() async {
    try {
      final prefs = Modular.get<SharedPreferences>();
      final order = prefs.getStringList('card_order');
      if (order != null && order.isNotEmpty) {
        homeStore.setCardOrder(order);
      }
    } catch (e) {
      debugPrint('Error loading card order: $e');
    }
  }

  Future<void> saveCardOrder() async {
    try {
      final prefs = Modular.get<SharedPreferences>();
      await prefs.setStringList('card_order', homeStore.cardOrder.toList());
    } catch (e) {
      debugPrint('Error saving card order: $e');
    }
  }

  void goToSicoobSettings() {
    Modular.to.pushNamed('/settings/sicoob-settings');
  }

  void goToBBSettings() {
    Modular.to.pushNamed('/settings/bb-settings');
  }

  Future<String?> setBBFavorite() async {
    if (apiStore.bbApiCredentialsEntity != null) {
      final targetId = authStore.loggedUser?.tenantId ?? authStore.loggedUser?.id ?? '';
      final database = authStore.loggedUser?.tenantId != null ? Database.cloud : Database.local;

      final currentCredentials = apiStore.bbApiCredentialsEntity!;
      final newIsFavorite = !currentCredentials.isFavorite;

      // Se o BB está sendo definido como favorito, desmarcar o Sicoob
      if (newIsFavorite && apiStore.sicoobApiCredentialsEntity?.isFavorite == true) {
        final sicoobCredentials = apiStore.sicoobApiCredentialsEntity!;
        await _updateSicoobApiCredentialsUseCase(
          id: targetId,
          database: database,
          sicoobApiCredentialsEntity: SicoobApiCredentialsEntity(
            clientID: sicoobCredentials.clientID,
            certificatePassword: sicoobCredentials.certificatePassword,
            certificateBase64String: sicoobCredentials.certificateBase64String,
            isFavorite: false,
          ),
        );
      }

      final bbCredentials = BBApiCredentialsEntity(
        applicationDeveloperKey: currentCredentials.applicationDeveloperKey,
        basicKey: currentCredentials.basicKey,
        isFavorite: newIsFavorite,
      );
      final result = await _updateBBApiCredentialsUseCase(
        id: targetId,
        database: database,
        bbApiCredentialsEntity: bbCredentials,
      );
      return result.fold(
        (success) async {
          await apiStore.loadData();
          return null;
        },
        (failure) => failure.message,
      );
    }
    return 'Erro ao ler credenciais de BB';
  }

  Future<String?> setSicoobFavorite() async {
    if (apiStore.sicoobApiCredentialsEntity != null) {
      final targetId = authStore.loggedUser?.tenantId ?? authStore.loggedUser?.id ?? '';
      final database = authStore.loggedUser?.tenantId != null ? Database.cloud : Database.local;

      final currentCredentials = apiStore.sicoobApiCredentialsEntity!;
      final newIsFavorite = !currentCredentials.isFavorite;

      // Se o Sicoob está sendo definido como favorito, desmarcar o BB
      if (newIsFavorite && apiStore.bbApiCredentialsEntity?.isFavorite == true) {
        final bbCredentials = apiStore.bbApiCredentialsEntity!;
        await _updateBBApiCredentialsUseCase(
          id: targetId,
          database: database,
          bbApiCredentialsEntity: BBApiCredentialsEntity(
            applicationDeveloperKey: bbCredentials.applicationDeveloperKey,
            basicKey: bbCredentials.basicKey,
            isFavorite: false,
          ),
        );
      }

      final sicoobCredentials = SicoobApiCredentialsEntity(
        clientID: currentCredentials.clientID,
        certificatePassword: currentCredentials.certificatePassword,
        certificateBase64String: currentCredentials.certificateBase64String,
        isFavorite: newIsFavorite,
      );
      final result = await _updateSicoobApiCredentialsUseCase(
        id: targetId,
        database: database,
        sicoobApiCredentialsEntity: sicoobCredentials,
      );
      return result.fold(
        (success) async {
          await apiStore.loadData();
          return null;
        },
        (failure) => failure.message,
      );
    }
    return 'Erro ao ler credenciais de Sicoob';
  }

  String _greetingOfTheDay() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    if (hour >= 6 && hour < 12) return "Bom dia!";
    if (hour >= 12 && hour < 18) return "Boa tarde!";
    return "Boa noite!";
  }

  String get greetingUserMessage => authStore.userName.capitalize();
  String get greetingDayMessage => _greetingOfTheDay();
}
