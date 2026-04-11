part of 'theme.dart';

IconButtonThemeData get _lightIconButtonTheme => IconButtonThemeData(
      style: ButtonStyle(
        iconColor:
            WidgetStateColor.resolveWith((states) => _lightColorScheme.primary),
      ),
    );
IconButtonThemeData get _darkIconButtonTheme => IconButtonThemeData(
      style: ButtonStyle(
          iconColor: WidgetStateColor.resolveWith(
        (states) => _darkColorScheme.primary,
      )),
    );
