import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:verify/app/core/auth_store.dart';
import 'package:verify/app/modules/auth/domain/usecase/tenant_usecases.dart';
import 'package:verify/app/modules/auth/presenter/onboarding/store/onboarding_store.dart';

class OnboardingController {
  final OnboardingStore _store;
  final TenantUseCases _tenantUseCases;
  final AuthStore _authStore = Modular.get<AuthStore>();

  final groupNameController = TextEditingController();
  final inviteCodeController = TextEditingController();

  OnboardingController(this._store, this._tenantUseCases);

  Future<void> submit(BuildContext context) async {
    _store.setLoading(true);
    try {
      final user = _authStore.loggedUser;
      if (user == null) return;

      if (_store.isGestor) {
        if (_store.groupName.isEmpty) {
          throw Exception('Digite o nome do grupo');
        }
        await _tenantUseCases.createTenant(_store.groupName, user.id);
      } else {
        if (_store.inviteCode.isEmpty) {
          throw Exception('Digite o código de convite');
        }
        await _tenantUseCases.joinTenant(_store.inviteCode, user.id);
      }

      // Reload user data to update profile/tenant in store
      await _authStore.loadData();

      // A navegação será automática via reação do AppStore.idealRoute no AppWidget
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _store.setLoading(false);
    }
  }

  void dispose() {
    groupNameController.dispose();
    inviteCodeController.dispose();
  }
}
