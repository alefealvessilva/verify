import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primaryContainer,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                colorScheme.onPrimary,
                BlendMode.srcIn,
              ),
              child: SvgPicture.asset(
                'assets/svg/logo.svg',
                height: 80,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Rápido, Simples e Seguro!',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
