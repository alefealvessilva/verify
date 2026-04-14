import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:verify/app/modules/auth/presenter/login/controller/login_controller.dart';
import 'package:verify/app/modules/auth/presenter/login/store/login_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:verify/app/shared/widgets/custom_snack_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = Modular.get<LoginController>();
  final store = Modular.get<LoginStore>();

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
              // Logo e Boas-vindas
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.security_rounded,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Bem-vindo ao Verify',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Transparência nos seus recebimentos Pix',
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
                      onEditingComplete: controller.passwordFocus.unfocus,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: controller.goToRecoverAccountPage,
                        child: const Text('Esqueceu a senha?'),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Observer(
                      builder: (_) => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed:
                              store.loginButtonEnabled ? _loginWithEmail : null,
                          child: store.loggingInWithEmail
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Entrar'),
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
                  const Text('Não tem uma conta?'),
                  TextButton(
                    onPressed: controller.goToRegisterPage,
                    child: const Text('Cadastre-se'),
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

  Future<void> _loginWithEmail() async {
    await controller.loginWithEmail().then((errorMessage) {
      if (errorMessage != null) {
        if (!mounted) return;
        var snackBarType = SnackBarType.error;
        ScaffoldMessenger.of(context).clearSnackBars();
        if (errorMessage.contains('Confirme seu email no link enviado')) {
          snackBarType = SnackBarType.info;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: errorMessage,
            snackBarType: snackBarType,
          ),
        );
      }
    });
  }
}

