import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:verify/app/core/auth_store.dart';
import 'package:verify/app/modules/auth/infra/models/user_permissions_model.dart';
import 'package:verify/app/modules/config/management/controller/member_management_controller.dart';
import 'package:verify/app/modules/config/management/store/member_management_store.dart';

class MemberManagementPage extends StatefulWidget {
  const MemberManagementPage({super.key});

  @override
  State<MemberManagementPage> createState() => _MemberManagementPageState();
}

class _MemberManagementPageState extends State<MemberManagementPage> {
  final controller = Modular.get<MemberManagementController>();
  final store = Modular.get<MemberManagementStore>();
  final authStore = Modular.get<AuthStore>();

  @override
  void initState() {
    super.initState();
    final tenantId = authStore.loggedUser?.tenantId;
    if (tenantId != null) {
      controller.loadMembers(tenantId);
    }
  }

  Color _getAvatarColor(String name) {
    if (name.isEmpty) return Colors.grey;
    final colors = [
      Colors.blue[400]!,
      Colors.purple[400]!,
      Colors.orange[400]!,
      Colors.teal[400]!,
      Colors.pink[400]!,
      Colors.indigo[400]!,
      Colors.amber[700]!,
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Gestão da Equipe'),
        centerTitle: true,
      ),
      body: Observer(
        builder: (_) {
          if (store.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filtrar usuário logado e Ordenar: Pendentes primeiro
          final filteredMembers = store.members
              .where((m) => m.id != authStore.loggedUser?.id)
              .toList();

          if (filteredMembers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_off_rounded,
                      size: 64, color: colorScheme.outlineVariant),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum outro membro encontrado.',
                    style: textTheme.bodyLarge
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            );
          }

          final sortedMembers = filteredMembers
            ..sort((a, b) {
              if (a.status == 'pending' && b.status != 'pending') return -1;
              if (a.status != 'pending' && b.status == 'pending') return 1;
              return a.name.compareTo(b.name);
            });

          return RefreshIndicator(
            onRefresh: () async {
              final tenantId = authStore.loggedUser?.tenantId;
              if (tenantId != null) await controller.loadMembers(tenantId);
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: sortedMembers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final member = sortedMembers[index];
                final isPending = member.status == 'pending';

                return Container(
                  decoration: BoxDecoration(
                    color: isPending
                        ? colorScheme.primary.withValues(alpha: 0.05)
                        : colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isPending
                          ? colorScheme.primary.withValues(alpha: 0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: isPending
                          ? colorScheme.primary
                          : _getAvatarColor(member.name),
                      child: Text(
                        member.name.isNotEmpty
                            ? member.name.substring(0, 1).toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: isPending
                              ? colorScheme.onPrimary
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      member.name,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(member.email, style: textTheme.bodySmall),
                        const SizedBox(height: 8),
                        _StatusChip(status: member.status),
                      ],
                    ),
                    trailing: isPending
                        ? FilledButton(
                            onPressed: () =>
                                _showApproveDialog(context, member.id),
                            style: FilledButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            child: const Text('Revisar'),
                          )
                        : IconButton(
                            icon: const Icon(Icons.settings_outlined),
                            onPressed: () => _showApproveDialog(
                              context,
                              member.id,
                              current: member.permissions,
                            ),
                          ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showApproveDialog(BuildContext context, String userId,
      {UserPermissions? current}) {
    bool canBB = current?.canViewBB ?? false;
    bool canSicoob = current?.canViewSicoob ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              title: const Text('Permissões de Acesso'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                      'Defina o que este operador poderá visualizar no aplicativo.'),
                  const SizedBox(height: 24),
                  _PermissionToggle(
                    title: 'Banco do Brasil',
                    value: canBB,
                    onChanged: (v) => setDialogState(() => canBB = v),
                    icon: Icons.account_balance_rounded,
                  ),
                  const SizedBox(height: 8),
                  _PermissionToggle(
                    title: 'Sicoob',
                    value: canSicoob,
                    onChanged: (v) => setDialogState(() => canSicoob = v),
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    controller.approveMember(
                      userId,
                      UserPermissions(
                          canViewBB: canBB, canViewSicoob: canSicoob),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _PermissionToggle extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;
  final IconData icon;

  const _PermissionToggle({
    required this.title,
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon,
                color:
                    value ? colorScheme.primary : colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Color color;
    String label;

    switch (status) {
      case 'approved':
        color = Colors.green[600]!;
        label = 'Ativo';
        break;
      case 'pending':
        color = colorScheme.primary;
        label = 'Solicitação Pendente';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
