import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verify/app/modules/auth/domain/entities/logged_user_info.dart';
import 'package:verify/app/modules/auth/domain/usecase/i_get_logged_user_usecase.dart';
import 'package:verify/app/modules/auth/domain/usecase/i_logout_usecase.dart';
import 'package:verify/app/modules/auth/infra/datasource/i_profile_datasource.dart';
import 'package:verify/app/modules/auth/infra/models/tenant_model.dart';
part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  StreamSubscription<AuthState>? _authSubscription;

  @observable
  bool loading = false;

  @observable
  bool isResettingPassword = false;

  @observable
  LoggedUserInfoEntity? loggedUser;

  @observable
  TenantModel? tenant;

  @action
  void setResettingPassword(bool value) {
    isResettingPassword = value;
  }

  @action
  void clearPasswordReset() {
    isResettingPassword = false;
  }

  @computed
  String get userName {
    String name = '';
    String subName = '';
    final splitted = loggedUser?.name.split(' ');
    if (splitted != null) {
      if (splitted.length >= 2) {
        name = splitted[0];
        subName = splitted[1];
      } else {
        name = splitted.first;
      }
    }

    return '$name $subName';
  }

  @action
  void setUser(LoggedUserInfoEntity? user) {
    loggedUser = user;
  }

  @action
  Future<void> loadData() async {
    try {
      loading = true;
      debugPrint('AuthStore: Starting loadData...');
      final useCase = Modular.get<IGetLoggedUserUseCase>();
      
      debugPrint('AuthStore: Fetching current user profile...');
      final user = await useCase();

      if (user == null) {
        debugPrint('AuthStore: No user session found.');
        loggedUser = null;
        tenant = null;
      } else {
        debugPrint('AuthStore: User loaded: ${user.id} | Role: ${user.role} | Status: ${user.status}');
        TenantModel? fetchedTenant;
        if (user.tenantId != null) {
          try {
            debugPrint('AuthStore: Fetching tenant details: ${user.tenantId}');
            final profileDataSource = Modular.get<IProfileDataSource>();
            fetchedTenant = await profileDataSource.getTenant(user.tenantId!);
            debugPrint('AuthStore: Tenant identity: ${fetchedTenant.name}');
          } catch (e) {
            debugPrint('Error loading tenant details: $e');
            fetchedTenant = null;
          }
        }
        
        // Atribui os dois campos de forma próxima ao final para evitar "pulos" de rota
        tenant = fetchedTenant;
        loggedUser = user;
      }
    } catch (e) {
      debugPrint('Critical error in AuthStore.loadData: $e');
      loggedUser = null;
      tenant = null;
    } finally {
      loading = false;
      debugPrint('AuthStore: loadData completed.');
    }
  }

  @action
  Future<void> signOut() async {
    try {
      final logoutUseCase = Modular.get<ILogoutUseCase>();
      await logoutUseCase();
    } finally {
      runInAction(() {
        loggedUser = null;
        tenant = null;
      });
      debugPrint('AuthStore: SignOut completed. State cleared.');
    }
  }

  void initAuthListener() {
    _authSubscription?.cancel();
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      debugPrint('AuthStore: onAuthStateChange event -> $event');

      if (event == AuthChangeEvent.passwordRecovery) {
        runInAction(() {
          isResettingPassword = true;
        });
      } else if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.userUpdated) {
        if (!isResettingPassword) {
          await loadData();
        }
      } else if (event == AuthChangeEvent.signedOut) {
        runInAction(() {
          isResettingPassword = false;
          loggedUser = null;
          tenant = null;
        });
      }
    });
  }

  @action
  void dispose() {
    _authSubscription?.cancel();
    _authSubscription = null;
    isResettingPassword = false;
    loading = false;
    loggedUser = null;
    tenant = null;
  }
}
