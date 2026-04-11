part of 'theme.dart';

AppBarTheme get _lightAppBarTheme => AppBarTheme(
      scrolledUnderElevation: 0,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: _lightColorScheme.onSurface,
      centerTitle: true,
      backgroundColor: _lightColorScheme.surface,
      titleTextStyle: TextStyle(
        color: _lightColorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(
        color: _lightColorScheme.primary,
      ),
    );

AppBarTheme get _darkAppBarTheme => AppBarTheme(
      scrolledUnderElevation: 0,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: _darkColorScheme.onSurface,
      centerTitle: true,
      backgroundColor: _darkColorScheme.surface,
      titleTextStyle: TextStyle(
        color: _darkColorScheme.onSurface,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(
        color: _darkColorScheme.primary,
      ),
    );
