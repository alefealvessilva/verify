import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:verify/app/core/auth_store.dart';
import 'package:verify/app/modules/home/controller/home_page_controller.dart';
import 'package:verify/app/modules/home/store/home_store.dart';
import 'package:verify/app/modules/home/view/widgets/account_card_page_view.dart';
import 'package:verify/app/shared/widgets/custom_navigation_bar.dart';
import 'package:verify/app/shared/widgets/pix_list_view_builder_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomePageController>();
  final homeStore = Modular.get<HomeStore>();
  final authStore = Modular.get<AuthStore>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final nf = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.fetchTransactions(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // Header & Search
              SliverAppBar(
                floating: true,
                pinned: true,
                expandedHeight: 140,
                backgroundColor: colorScheme.surface,
                elevation: 0,
                scrolledUnderElevation: 0,
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
                        onChanged: homeStore.setSearchQuery,
                        decoration: InputDecoration(
                          hintText: 'Pesquisar pagador...',
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
                actions: [
                  IconButton(
                    onPressed: () => Modular.to.pushNamed('/settings'),
                    icon: const Icon(Icons.person_outline_rounded),
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // Greeting
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, ${authStore.userName.split(' ').first}!',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Seja bem-vindo de volta',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bank Cards
              const SliverToBoxAdapter(
                child: AccountCardPageView(),
              ),

              // Dashboard
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.bolt_rounded, color: colorScheme.primary, size: 32),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Recebido (Pix)',
                                    style: textTheme.labelMedium?.copyWith(
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  Observer(builder: (_) {
                                    final total = homeStore.totalReceivedCalculated;
                                    final isLoading = homeStore.isLoadingTransactions;
                                    
                                    return Text(
                                      isLoading ? 'R\$ --,--' : nf.format(total), 
                                      style: textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Filters
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transações',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Observer(builder: (context) {
                              return DropdownButton<int>(
                                value: homeStore.selectedFilter,
                                underline: const SizedBox(),
                                icon: Icon(Icons.keyboard_arrow_down_rounded,
                                    size: 20, color: colorScheme.primary),
                                items: const [
                                  DropdownMenuItem(value: 0, child: Text('Hoje')),
                                  DropdownMenuItem(value: 1, child: Text('Ontem')),
                                  DropdownMenuItem(value: 2, child: Text('Semana')),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    controller.updateFilter(val);
                                  }
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Passive Transactions List
              Observer(builder: (context) {
                return PixListViewBuilder(
                  useSliver: true,
                  transactions: homeStore.filteredTransactions,
                  isLoading: homeStore.isLoadingTransactions,
                  searchQuery: homeStore.searchQuery,
                );
              }),

              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
