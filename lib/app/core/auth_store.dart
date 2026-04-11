import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:verify/app/modules/auth/domain/entities/logged_user_info.dart';
import 'package:verify/app/modules/auth/domain/usecase/get_logged_user_usecase.dart';
import 'package:verify/app/modules/auth/domain/usecase/logout_usecase.dart';
import 'package:verify/app/modules/auth/infra/datasource/profile_datasource.dart';
import 'package:verify/app/modules/auth/infra/models/tenant_model.dart';
part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  @observable
  bool loading = false;

  @observable
  LoggedUserInfoEntity? loggedUser;

  @observable
  TenantModel? tenant;

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
      final useCase = Modular.get<GetLoggedUserUseCase>();
      
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
            final profileDataSource = Modular.get<ProfileDataSource>();
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
      final logoutUseCase = Modular.get<LogoutUseCase>();
      await logoutUseCase();
    } finally {
      runInAction(() {
        loggedUser = null;
        tenant = null;
      });
      debugPrint('AuthStore: SignOut completed. State cleared.');
    }
  }

  @action
  void dispose() {
    loading = false;
    loggedUser = null;
    tenant = null;
  }
}
