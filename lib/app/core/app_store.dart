import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:verify/app/modules/auth/domain/entities/logged_user_info.dart';
import 'package:verify/app/modules/database/domain/usecase/user_preferences_usecases/read_user_theme_mode_preference_usecase.dart';
import 'package:verify/app/core/auth_store.dart';

part 'app_store.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  final AuthStore _authStore;

  AppStoreBase(this._authStore);

  @observable
  bool loading = false;

  @observable
  var themeMode = Observable<ThemeMode>(ThemeMode.system);

  @observable
  var currentDestination = Observable<int>(0);

  @computed
  String get idealRoute {
    final user = _authStore.loggedUser;

    final route = _calculateIdealRoute(user);
    debugPrint(
        'AppStore: IdealRoute calculated: $route (User: ${user?.id}, Status: ${user?.status}, Role: ${user?.role})');
    return route;
  }

  String _calculateIdealRoute(LoggedUserInfoEntity? user) {
    if (user == null) return '/auth/login';

    if (user.role == 'none' || user.tenantId == null || user.role.isEmpty) {
      return '/auth/onboarding';
    }

    if (user.status == 'pending') {
      return '/auth/waiting-approval';
    }

    if (user.status == 'approved') {
      return '/home';
    }

    return '/auth/login';
  }

  @action
  void setPreferredTheme(ThemeMode theme) {
    themeMode.value = theme;
  }

  @action
  void setCurrentDestination(int destination) {
    currentDestination.value = destination;
  }

  Future<void> loadData() async {
    loading = true;
    final readUserThemePreference =
        Modular.get<ReadUserThemeModePreferenceUseCase>();
    final mode = await readUserThemePreference();
    final themeResult = mode.getOrNull();
    if (themeResult != null) {
      setPreferredTheme(themeResult);
    }
    loading = false;
  }

  @action
  void dispose() {
    themeMode.value = ThemeMode.system;
    currentDestination.value = 0;
    loading = false;
  }
}
