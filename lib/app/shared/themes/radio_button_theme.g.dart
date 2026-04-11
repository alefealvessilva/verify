part of 'theme.dart';

RadioThemeData get _lightRadioTheme => RadioThemeData(
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _lightColorScheme.primary;
        } else {
          return _lightColorScheme.secondary;
        }
      }),
    );

RadioThemeData get _darkRadioTheme => RadioThemeData(
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _darkColorScheme.primary;
        } else {
          return _darkColorScheme.secondary;
        }
      }),
    );
