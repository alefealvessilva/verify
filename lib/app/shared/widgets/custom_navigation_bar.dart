import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
              color: colorScheme.surfaceContainerHigh, // Adaptativo ao tema
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.grid_view_rounded,
                  label: 'Home',
                  isSelected: currentDestination == 0,
                  onTap: () => _onTabSelected(0, currentDestination),
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.history_rounded,
                  label: 'History',
                  isSelected: currentDestination == 1,
                  onTap: () => _onTabSelected(1, currentDestination),
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  isSelected: currentDestination == 2,
                  onTap: () => _onTabSelected(2, currentDestination),
                ),
              ],
            ),
          ),
        );
      },
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          icon,
          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          size: 28,
        ),
      ),
    );
  }
}
