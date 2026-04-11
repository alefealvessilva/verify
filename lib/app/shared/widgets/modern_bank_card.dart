import 'package:flutter/material.dart';

class ModernBankCard extends StatelessWidget {
  final String bankName;
  final String accountType;
  final String? balance;
  final List<Color> gradientColors;
  final VoidCallback? onTap;
  final bool hasCredentials;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const ModernBankCard({
    super.key,
    required this.bankName,
    required this.accountType,
    this.balance,
    required this.gradientColors,
    this.onTap,
    this.hasCredentials = false,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: hasCredentials ? null : onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: hasCredentials
                ? gradientColors
                : [colorScheme.surfaceContainerHighest, colorScheme.outline],
          ),
          boxShadow: [
            BoxShadow(
              color: (hasCredentials ? gradientColors[0] : colorScheme.shadow)
                  .withValues(
                      alpha: theme.brightness == Brightness.dark ? 0.15 : 0.3),
              blurRadius: 24,
              spreadRadius: -4,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Decorative circle for glassmorphism
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bankName,
                              style: textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              accountType,
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        if (hasCredentials)
                          IconButton(
                            onPressed: onFavoriteTap,
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Icon(
                                isFavorite
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                key: ValueKey<bool>(isFavorite),
                                color: isFavorite 
                                    ? Colors.yellow // Amarelo vibrante solicitado
                                    : Colors.white70,
                                size: 28,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    if (!hasCredentials)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Configurar Conta',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
