import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:verify/app/modules/auth/presenter/recover/controller/recover_account_page_controller.dart';
import 'package:verify/app/modules/auth/presenter/recover/store/recover_account_store.dart';
import 'package:verify/app/shared/widgets/custom_snack_bar.dart';

class RecoverAccountPage extends StatefulWidget {
  const RecoverAccountPage({super.key});

  @override
  State<RecoverAccountPage> createState() => _RecoverAccountPageState();
}

class _RecoverAccountPageState extends State<RecoverAccountPage> {
  final controller = Modular.get<RecoverAccountPageController>();
  final store = Modular.get<RecoverAccountPageStore>();
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
          onPressed: controller.backToLoginPage,
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
                'Recupere sua conta',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Digite seu e-mail e enviaremos as instruções para redefinir sua senha',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 48),

              // Formulário
              Form(
                key: controller.formKey,
                onChanged: controller.validateField,
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
                      onEditingComplete: controller.emailFocus.unfocus,
                    ),
                    const SizedBox(height: 48),

                    Observer(
                      builder: (_) => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: store.enableRecoverButton
                              ? _sendRecoverInstructions
                              : null,
                          child: store.recovertingWithEmail
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Enviar instruções'),
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

  _sendRecoverInstructions() {
    ScaffoldMessenger.of(context).clearSnackBars();
    controller.sendRecoverInstructions().then((errorMessage) {
      if (!mounted) return;
      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: 'Enviamos as instruções para seu email',
            snackBarType: SnackBarType.success,
          ),
        );
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
