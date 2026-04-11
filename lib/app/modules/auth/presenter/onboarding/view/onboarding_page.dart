import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:verify/app/core/auth_store.dart';
import 'package:verify/app/modules/auth/presenter/onboarding/controller/onboarding_controller.dart';
import 'package:verify/app/modules/auth/presenter/onboarding/store/onboarding_store.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = Modular.get<OnboardingController>();
  final store = Modular.get<OnboardingStore>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Observer(
            builder: (_) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Align(
                    alignment: Alignment.centerRight,
                    child: IconButton.filledTonal(
                      onPressed: () async {
                        final authStore = Modular.get<AuthStore>();
                        await authStore.signOut();
                        Modular.to.navigate('/auth/login');
                      },
                      icon: const Icon(Icons.logout_rounded),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Como deseja começar?',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecione seu perfil para configurar sua conta no Verify.',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 32),
                  
                  // Cards de Seleção
                  Row(
                    children: [
                      Expanded(
                        child: _ModernRoleCard(
                          title: 'Gestor',
                          description: 'Criar um novo grupo seguro',
                          icon: Icons.business_center_rounded,
                          isSelected: store.isGestor,
                          onTap: () => store.setGestor(true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ModernRoleCard(
                          title: 'Operador',
                          description: 'Entrar em um grupo existente',
                          icon: Icons.person_add_alt_1_rounded,
                          isSelected: !store.isGestor,
                          onTap: () => store.setGestor(false),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Formulários Animados
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.05, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: store.isGestor
                          ? _buildGestorForm(colorScheme, textTheme)
                          : _buildOperadorForm(colorScheme, textTheme),
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  SizedBox(
                    height: 56,
                    child: FilledButton(
                      onPressed: store.canContinue && !store.loading
                          ? () => controller.submit(context)
                          : null,
                      child: store.loading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Configurar Conta'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGestorForm(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      key: const ValueKey('gestor'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configurar Grupo',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: store.setGroupName,
          decoration: const InputDecoration(
            labelText: 'Nome do Grupo',
            hintText: 'Ex: Equipe de Vendas',
            prefixIcon: Icon(Icons.drive_file_rename_outline_rounded),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
               Icon(Icons.info_outline_rounded, color: colorScheme.secondary),
               const SizedBox(width: 12),
               const Expanded(
                 child: Text(
                   'Você será o administrador deste grupo e poderá convidar outros membros.',
                   style: TextStyle(fontSize: 13),
                 ),
               ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOperadorForm(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      key: const ValueKey('operador'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Entrar em um Grupo',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: store.setInviteCode,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium?.copyWith(
            letterSpacing: 8,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
          decoration: const InputDecoration(
            labelText: 'Código de Convite',
            hintText: '000000',
            counterText: '',
            prefixIcon: Icon(Icons.vpn_key_outlined),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Insira o código de 6 caracteres enviado pelo seu gestor.',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _ModernRoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModernRoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? colorScheme.primaryContainer 
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: textTheme.bodySmall?.copyWith(
                color: isSelected ? colorScheme.onPrimaryContainer.withValues(alpha: 0.7) : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
