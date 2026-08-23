import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:verify/app/modules/auth/domain/usecase/i_update_password_usecase.dart';
import 'package:verify/app/modules/auth/presenter/reset_password/store/reset_password_store.dart';
import 'package:verify/app/core/auth_store.dart';
import 'package:verify/app/modules/auth/utils/password_regex.dart';

class ResetPasswordController {
  final IUpdatePasswordUseCase _updatePasswordUseCase;
  final ResetPasswordStore _store;

  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();

  ResetPasswordController(
    this._updatePasswordUseCase,
    this._store,
  );

  void goToLoginPage() {
    dispose();
    Modular.get<AuthStore>().clearPasswordReset();
    Modular.to.pushReplacementNamed('/auth/login');
  }

  String? autoValidatePassword(String? passwordInput) {
    if (passwordRegex.hasMatch(passwordInput ?? '')) {
      return null;
    } else {
      return 'Senha deve ter no mínimo 8 caracteres';
    }
  }

  String? autoValidateConfirmPassword(String? confirmPasswordInput) {
    if (passwordRegex.hasMatch(confirmPasswordInput ?? '')) {
      if (confirmPasswordInput == passwordController.text) {
        return null;
      } else {
        return 'As senhas estão divergentes';
      }
    } else {
      return 'Senha deve ter no mínimo 8 caracteres';
    }
  }

  void validateFields() {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      _store.validateField(true);
    } else {
      _store.validateField(false);
    }
  }

  Future<String?> updatePassword() async {
    try {
      passwordFocus.unfocus();
      confirmPasswordFocus.unfocus();
      _store.updatingInProgress(true);
      final result = await _updatePasswordUseCase(
        newPassword: passwordController.text,
      );

      return result.fold(
        (success) => null,
        (failure) => failure.message,
      );
    } finally {
      _store.updatingInProgress(false);
    }
  }

  void dispose() {
    passwordController.clear();
    confirmPasswordController.clear();
    _store.validateField(false);
    _store.updatingInProgress(false);
  }
}
