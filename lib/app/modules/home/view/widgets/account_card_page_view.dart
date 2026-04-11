import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:verify/app/core/api_credentials_store.dart';
import 'package:verify/app/modules/home/controller/home_page_controller.dart';
import 'package:verify/app/modules/home/store/home_store.dart';
import 'package:verify/app/shared/widgets/modern_bank_card.dart';

class AccountCardPageView extends StatefulWidget {
  const AccountCardPageView({super.key});

  @override
  State<AccountCardPageView> createState() => _AccountCardPageViewState();
}

class _AccountCardPageViewState extends State<AccountCardPageView> {
  final apiStore = Modular.get<ApiCredentialsStore>();
  final controller = Modular.get<HomePageController>();
  final homeStore = Modular.get<HomeStore>();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: homeStore.visibleCardIndex,
      viewportFraction: 0.85,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleFavorite(String id) async {
    String? error;
    if (id == 'sicoob') {
      error = await controller.setSicoobFavorite();
    } else {
      error = await controller.setBBFavorite();
    }

    if (error == null) {
      homeStore.updateOrderBasedOnFavorites(id);
      await controller.saveCardOrder();

      // Ao favoritar, movemos para o início e forçamos refresh via handleAccountChange
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutExpo,
      );
      controller.handleAccountChange(0);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final orderedAccounts = homeStore.cardOrder
            .map((id) {
              return apiStore.listAccounts.firstWhere(
                (acc) => acc.containsValue(id),
                orElse: () => <String, dynamic>{},
              );
            })
            .where((acc) => acc.isNotEmpty)
            .toList();

        return SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              // Notifica o controlador sobre a mudança para resetar filtros e carregar dados
              controller.handleAccountChange(index);
            },
            itemCount: orderedAccounts.length,
            itemBuilder: (context, index) {
              final account = orderedAccounts[index];
              final isSicoob = account.containsValue('sicoob');
              final id = isSicoob ? 'sicoob' : 'bancoDoBrasil';

              final isFavorite = isSicoob
                  ? (apiStore.sicoobApiCredentialsEntity?.isFavorite ?? false)
                  : (apiStore.bbApiCredentialsEntity?.isFavorite ?? false);

              final bankName = isSicoob ? 'Sicoob' : 'Banco do Brasil';
              final gradient = isSicoob
                  ? [const Color(0xFF00AE42), const Color(0xFF2D3277)]
                  : [const Color(0xFF0038A8), const Color(0xFF002164)];

              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.1)).clamp(0.9, 1.0);
                  } else {
                    value = index == homeStore.visibleCardIndex ? 1.0 : 0.9;
                  }

                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ModernBankCard(
                    bankName: bankName,
                    accountType: 'Conta Empresarial',
                    gradientColors: gradient,
                    hasCredentials: account['hasCredentials'],
                    isFavorite: isFavorite,
                    onFavoriteTap: () => _handleFavorite(id),
                    onTap: () {
                      if (isSicoob) {
                        controller.goToSicoobSettings();
                      } else {
                        controller.goToBBSettings();
                      }
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
