part of 'theme.dart';

FilledButtonThemeData get _lightFilledButtonThemeData => FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(131, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );

FilledButtonThemeData get _darkFilledButtonThemeData => FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(131, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
