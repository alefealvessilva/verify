import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:verify/app/modules/auth/presenter/reset_password/controller/reset_password_controller.dart';
import 'package:verify/app/modules/auth/presenter/reset_password/store/reset_password_store.dart';
import 'package:verify/app/shared/widgets/custom_snack_bar.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final controller = Modular.get<ResetPasswordController>();
  final store = Modular.get<ResetPasswordStore>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: controller.goToLoginPage,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              // Logo e Título
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Nova Senha',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Digite e confirme a sua nova senha de acesso',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),

              // Formulário
              Form(
                key: controller.formKey,
                onChanged: controller.validateFields,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.passwordController,
                      focusNode: controller.passwordFocus,
                      obscureText: _obscurePassword,
                      validator: controller.autoValidatePassword,
                      decoration: InputDecoration(
                        labelText: 'Nova senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      onEditingComplete: controller.confirmPasswordFocus.requestFocus,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.confirmPasswordController,
                      focusNode: controller.confirmPasswordFocus,
                      obscureText: _obscureConfirmPassword,
                      validator: controller.autoValidateConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirmar nova senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      onEditingComplete: controller.confirmPasswordFocus.unfocus,
                    ),
                    const SizedBox(height: 48),

                    Observer(
                      builder: (_) => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: store.isValid && !store.isUpdating
                              ? _handleUpdatePassword
                              : null,
                          child: store.isUpdating
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Salvar nova senha'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  void _handleUpdatePassword() {
    ScaffoldMessenger.of(context).clearSnackBars();
    controller.updatePassword().then((errorMessage) {
      if (!mounted) return;
      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: 'Senha alterada com sucesso!',
            snackBarType: SnackBarType.success,
          ),
        );
        controller.goToLoginPage();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: errorMessage,
            snackBarType: SnackBarType.error,
          ),
        );
      }
    });
  }
}
