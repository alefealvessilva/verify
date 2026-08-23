import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:verify/app/shared/themes/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = lightTheme.colorScheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.surface,
                colorScheme.surfaceContainerHighest,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                      child: SvgPicture.asset(
                        'assets/svg/logo.svg',
                        height: 80,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Verify',
                  style: lightTheme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.5,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Segurança além do óbvio',
                  textAlign: TextAlign.center,
                  style: lightTheme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 64),
                CircularProgressIndicator(
                  strokeWidth: 3,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
