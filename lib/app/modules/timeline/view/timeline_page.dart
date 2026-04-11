import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:verify/app/core/api_credentials_store.dart';
import 'package:verify/app/modules/timeline/controller/timeline_controller.dart';
import 'package:verify/app/modules/timeline/store/timeline_store.dart';
import 'package:verify/app/shared/widgets/custom_navigation_bar.dart';
import 'package:verify/app/shared/widgets/empty_account_widget.dart';
import 'package:verify/app/shared/widgets/pix_list_view_builder_widget.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final controller = Modular.get<TimelineController>();
  final store = Modular.get<TimelineStore>();
  final apiStore = Modular.get<ApiCredentialsStore>();
  
  @override
  void initState() {
    super.initState();
    controller.fetchTransactions();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final theme = Theme.of(context);
    final initialRange = store.selectedDateRange;
    
    final newRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: initialRange,
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              surface: theme.colorScheme.surface,
              onSurface: theme.colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (newRange != null) {
      if (!context.mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      final difference = newRange.end.difference(newRange.start).inDays;
      if (difference > 31) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Selecione um intervalo de no máximo 31 dias.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      controller.updateDateRange(newRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 180,
              backgroundColor: colorScheme.surface,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text(
                'Timeline',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: false,
              actions: [
                Observer(builder: (_) {
                  return TextButton.icon(
                    onPressed: () => _selectDateRange(context),
                    icon: Icon(Icons.calendar_today_rounded, size: 18, color: colorScheme.primary),
                    label: Text(
                      _formatRangeLabel(store.selectedDateRange),
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 8),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      onChanged: store.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Filtrar por nome...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search_rounded, color: colorScheme.primary),
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Account Filter Tabs
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              sliver: SliverToBoxAdapter(
                child: Observer(builder: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _TimelineAccountButton(
                        onTap: () => controller.selectAccount(0),
                        title: 'Sicoob',
                        selected: store.selectedAccountIndex == 0,
                      ),
                      const SizedBox(width: 16),
                      _TimelineAccountButton(
                        onTap: () => controller.selectAccount(1),
                        title: 'Banco do Brasil',
                        selected: store.selectedAccountIndex == 1,
                      ),
                    ],
                  );
                }),
              ),
            ),

            // Passive Transactions List
            Observer(builder: (_) {
              if (apiStore.hasApiCredentials) {
                return PixListViewBuilder(
                  useSliver: true,
                  transactions: store.transactions,
                  isLoading: store.isLoadingTransactions,
                  searchQuery: store.searchQuery,
                );
              }
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyAccountWidget(),
              );
            }),

            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }

  String _formatRangeLabel(DateTimeRange range) {
    final start = DateFormat('dd/MM', 'pt_BR').format(range.start);
    final end = DateFormat('dd/MM', 'pt_BR').format(range.end);
    if (start == end) return start;
    return '$start - $end';
  }
}

class _TimelineAccountButton extends StatelessWidget {
  final String title;
  final bool selected;
  final void Function() onTap;

  const _TimelineAccountButton({
    required this.title,
    required this.onTap,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: selected ? colorScheme.primary : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            boxShadow: selected ? [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
          child: Text(
            title,
            style: textTheme.labelLarge?.copyWith(
              color: selected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
