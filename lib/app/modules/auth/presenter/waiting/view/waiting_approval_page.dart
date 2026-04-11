import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:verify/app/core/auth_store.dart';
import 'package:verify/app/modules/auth/infra/datasource/profile_datasource.dart';

class WaitingApprovalPage extends StatefulWidget {
  const WaitingApprovalPage({super.key});

  @override
  State<WaitingApprovalPage> createState() => _WaitingApprovalPageState();
}

class _WaitingApprovalPageState extends State<WaitingApprovalPage> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final authStore = Modular.get<AuthStore>();
    final profileDataSource = Modular.get<ProfileDataSource>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ilustração/Ícone
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Hero(
                    tag: 'status_icon',
                    child: Icon(
                      Icons.hourglass_empty_rounded,
                      size: 80,
                      color: Colors.amber[700],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Solicitação Enviada',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'O gestor do grupo foi notificado e revisará seu acesso em breve.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 48),

                // Ações
                if (_loading)
                  const CircularProgressIndicator()
                else ...[
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: () async {
                        setState(() => _loading = true);
                        await authStore.loadData();
                        if (authStore.loggedUser?.status != 'approved') {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Sua solicitação ainda está em análise.'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                        setState(() => _loading = false);
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Atualizar Status'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _confirmCancel(context, profileDataSource, authStore),
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('Cancelar Pedido'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 64),
                const Divider(),
                const SizedBox(height: 24),
                TextButton.icon(
                  onPressed: () async {
                    await authStore.signOut();
                    // A navegação ocorrerá automaticamente pelo AppWidget reagindo ao signOut
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sair e entrar com outra conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmCancel(
      BuildContext context, ProfileDataSource ds, AuthStore store) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Solicitação'),
        content: const Text(
            'Deseja cancelar seu pedido de entrada neste grupo? Você poderá solicitar novamente depois.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Manter'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sim, cancelar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _loading = true);
      try {
        await ds.cancelJoinRequest(store.loggedUser!.id);
        await store.loadData();
        // A navegação ocorrerá automaticamente pelo AppWidget reagindo a mudança
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    }
  }
}
