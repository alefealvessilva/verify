import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:verify/app/modules/auth/domain/entities/register_credentials_entity.dart';
import 'package:verify/app/modules/auth/domain/usecase/i_register_with_email_usecase.dart';
import 'package:verify/app/modules/auth/presenter/register/store/register_store.dart';
import 'package:verify/app/modules/auth/utils/email_regex.dart';
import 'package:verify/app/modules/auth/utils/password_regex.dart';

class RegisterController {
  final RegisterStore _registerStore;
  final IRegisterWithEmailUseCase _registerWithEmailUseCase;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();

  RegisterController(
    this._registerStore,
    this._registerWithEmailUseCase,
  );

  void goToLoginPage() {
    dispose();
    Modular.to.pushReplacementNamed('/auth/login');
  }

  Future<String?> registerWithEmail() async {
    try {
      emailFocus.unfocus();
      passwordFocus.unfocus();
      confirmPasswordFocus.unfocus();
      _registerStore.registeringWithEmailInProgress(true);
      final registerCredentials = RegisterCredentialsEntity(
        email: emailController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      final result = await _registerWithEmailUseCase(registerCredentials);

      return result.fold(
        (user) {
          return null;
        },
        (failure) {
          return failure.message;
        },
      );
    } finally {
      _registerStore.registeringWithEmailInProgress(false);
    }
  }

  void validateFields() {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      _registerStore.isValidFields(true);
    } else {
      _registerStore.isValidFields(false);
    }
  }

  String? autoValidateEmail(String? emailInput) {
    if (emailRegex.hasMatch(emailInput ?? '')) {
      return null;
    } else {
      return 'Digite um email válido';
    }
  }

  String? autoValidatePassword(String? passwordInput) {
    if (passwordRegex.hasMatch(passwordInput ?? '')) {
      return null;
    } else {
      return 'Senha deve ter no minimo 8 caracteres';
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
      return 'Senha deve ter no minimo 8 caracteres';
    }
  }

  void dispose() {
    emailController.text = '';
    passwordController.text = '';
    confirmPasswordController.text = '';
    _registerStore.isValidFields(false);
    _registerStore.registeringWithEmailInProgress(false);
    _registerStore.registeringWithGoogleInProgress(false);
  }
}
