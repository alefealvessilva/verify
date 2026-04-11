import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:verify/app/modules/auth/presenter/register/controller/register_controller.dart';
import 'package:verify/app/modules/auth/presenter/register/store/register_store.dart';
import 'package:verify/app/shared/widgets/custom_snack_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controller = Modular.get<RegisterController>();
  final store = Modular.get<RegisterStore>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 64),
              // Logo e Título
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_add_rounded,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Criar sua conta',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cadastre-se para começar no Verify',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 64),

              // Formulário
              Form(
                key: controller.formKey,
                onChanged: controller.validateFields,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.emailController,
                      focusNode: controller.emailFocus,
                      keyboardType: TextInputType.emailAddress,
                      validator: controller.autoValidateEmail,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      onEditingComplete: controller.passwordFocus.requestFocus,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.passwordController,
                      focusNode: controller.passwordFocus,
                      obscureText: true,
                      validator: controller.autoValidatePassword,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                      onEditingComplete:
                          controller.confirmPasswordFocus.requestFocus,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller.confirmPasswordController,
                      focusNode: controller.confirmPasswordFocus,
                      obscureText: true,
                      validator: controller.autoValidateConfirmPassword,
                      decoration: const InputDecoration(
                        labelText: 'Confirme a senha',
                        prefixIcon: Icon(Icons.lock_reset_rounded),
                      ),
                      onEditingComplete:
                          controller.confirmPasswordFocus.unfocus,
                    ),
                    const SizedBox(height: 48),

                    Observer(
                      builder: (_) => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: store.registerButtonEnabled
                              ? _registerWithEmail
                              : null,
                          child: store.registeringWithEmail
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Cadastrar'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Já tem uma conta?'),
                  TextButton(
                    onPressed: controller.goToLoginPage,
                    child: const Text('Entrar'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerWithEmail() async {
    await controller.registerWithEmail().then((errorMessage) {
      if (!mounted) return;
      if (errorMessage != null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: errorMessage,
            snackBarType: SnackBarType.error,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: 'Confirme seu email no link enviado',
            snackBarType: SnackBarType.info,
          ),
        );
      }
    });
  }
}
