import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:verify/app/core/api_credentials_store.dart';
import 'package:verify/app/core/app_store.dart';
import 'package:verify/app/core/auth_store.dart';
import 'package:verify/app/modules/config/settings/controller/settings_page_controller.dart';
import 'package:verify/app/modules/config/settings/view/widgets/accounts_list_tile_widget.dart';
import 'package:verify/app/shared/widgets/custom_navigation_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final appStore = Modular.get<AppStore>();
  final authStore = Modular.get<AuthStore>();
  final apiStore = Modular.get<ApiCredentialsStore>();
  final controller = Modular.get<SettingsPageController>();

  @override
  void initState() {
    apiStore.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isAdmin = authStore.loggedUser?.role == 'admin';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Ajustes'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Observer(builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section Card
                _SettingsCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor:
                            colorScheme.primary.withValues(alpha: 0.1),
                        child: Text(
                          authStore.userName.substring(0, 1).toUpperCase(),
                          style: textTheme.headlineSmall
                              ?.copyWith(color: colorScheme.primary),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authStore.userName,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              authStore.loggedUser?.email ?? '',
                              style: textTheme.bodySmall
                                  ?.copyWith(color: colorScheme.outline),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: controller.logout,
                        color: colorScheme.secondaryContainer,
                        icon: Icon(Icons.logout_rounded,
                            size: 20, color: colorScheme.onSecondaryContainer),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                Text('Preferências',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    )),
                const SizedBox(height: 12),
                _SettingsCard(
                  child: Column(
                    children: [
                      _ThemeOption(
                        icon: Icons.brightness_auto_rounded,
                        label: 'Sistema',
                        mode: ThemeMode.system,
                        current: appStore.themeMode.value,
                        onTap: () => controller.changeTheme(ThemeMode.system),
                      ),
                      Divider(height: 1, color: colorScheme.outlineVariant),
                      _ThemeOption(
                        icon: Icons.light_mode_rounded,
                        label: 'Claro',
                        mode: ThemeMode.light,
                        current: appStore.themeMode.value,
                        onTap: () => controller.changeTheme(ThemeMode.light),
                      ),
                      Divider(height: 1, color: colorScheme.outlineVariant),
                      _ThemeOption(
                        icon: Icons.dark_mode_rounded,
                        label: 'Escuro',
                        mode: ThemeMode.dark,
                        current: appStore.themeMode.value,
                        onTap: () => controller.changeTheme(ThemeMode.dark),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                Text('Contas Vinculadas',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    )),
                const SizedBox(height: 12),
                _SettingsCard(
                  child: Column(
                    children: [
                      AccountListTile(
                        bank: Bank.sicoob,
                        hasCredentials:
                            apiStore.sicoobApiCredentialsEntity != null,
                        onTap: isAdmin ? controller.goToSicoobSettings : null,
                      ),
                      Divider(height: 24, color: colorScheme.outlineVariant),
                      AccountListTile(
                        bank: Bank.bancoDoBrasil,
                        hasCredentials: apiStore.bbApiCredentialsEntity != null,
                        onTap: isAdmin ? controller.goToBBSettings : null,
                      ),
                      if (!isAdmin) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline_rounded,
                                  size: 16, color: colorScheme.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Apenas administradores podem gerenciar as contas.',
                                  style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                if (authStore.tenant != null) ...[
                  const SizedBox(height: 32),
                  Text('Gestão do Grupo',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      )),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: colorScheme.secondary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.group_work_rounded,
                                  color: colorScheme.secondary),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(authStore.tenant?.name ?? '',
                                      style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      )),
                                  Text(
                                    'Código: ${authStore.tenant?.inviteCode}',
                                    style: textTheme.bodySmall
                                        ?.copyWith(color: colorScheme.outline),
                                  ),
                                ],
                              ),
                            ),
                            IconButton.filledTonal(
                              icon: const Icon(Icons.copy_rounded, size: 18),
                              onPressed: () {}, // Clipboard logic
                            ),
                          ],
                        ),
                        if (isAdmin) ...[
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () =>
                                  Modular.to.pushNamed('/settings/management'),
                              icon: const Icon(Icons.manage_accounts_rounded),
                              label: const Text('Membros da Equipe'),
                              style: FilledButton.styleFrom(
                                backgroundColor: colorScheme.onSurface,
                                foregroundColor: colorScheme.surface,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 48),
                _DevelopedWith(),
                const SizedBox(height: 100),
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;
  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeMode mode;
  final ThemeMode current;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.mode,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == current;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color: isSelected ? colorScheme.primary : colorScheme.outline),
            const SizedBox(width: 16),
            Text(label,
                style: TextStyle(
                  color:
                      isSelected ? colorScheme.onSurface : colorScheme.outline,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                )),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle_rounded,
                  size: 18, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}

class _DevelopedWith extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(color: colorScheme.outline);
    return Center(
      child: Column(
        children: [
          Text('DEVELOPED WITH ♥ BY',
              style: textStyle?.copyWith(letterSpacing: 1.5, fontSize: 10)),
          const SizedBox(height: 8),
          Text('ACXTECH SISTEMAS',
              style: textStyle?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              )),
        ],
      ),
    );
  }
}
