import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verify/app/core/app_store.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appStore = Modular.get<AppStore>();

    return Observer(
      builder: (context) {
        final currentDestination = appStore.currentDestination.value;
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: BackdropFilter(
                filter:
                    ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      context: context,
                      icon: Icons.receipt_long_rounded,
                      label: 'Transações',
                      isSelected: currentDestination == 1,
                      onTap: () => _onTabSelected(1, currentDestination),
                    ),
                    _buildCentralLogoItem(
                      context: context,
                      isSelected: currentDestination == 0,
                      onTap: () => _onTabSelected(0, currentDestination),
                    ),
                    _buildNavItem(
                      context: context,
                      icon: Icons.settings_rounded,
                      label: 'Ajustes',
                      isSelected: currentDestination == 2,
                      onTap: () => _onTabSelected(2, currentDestination),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCentralLogoItem({
    required BuildContext context,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: isSelected
                ? [colorScheme.primary, colorScheme.secondary]
                : [colorScheme.surfaceContainerHighest, colorScheme.surfaceContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Center(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
              BlendMode.srcIn,
            ),
            child: SvgPicture.asset(
              'assets/svg/logo.svg',
              height: 28,
            ),
          ),
        ),
      ),
    );
  }

  void _onTabSelected(int index, int current) {
    final appStore = Modular.get<AppStore>();
    appStore.setCurrentDestination(index);
    if (index != current) {
      switch (index) {
        case 0:
          Modular.to.pushReplacementNamed('/home');
          break;
        case 1:
          Modular.to.pushReplacementNamed('/timeline');
          break;
        case 2:
          Modular.to.pushReplacementNamed('/settings');
          break;
      }
    }
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
