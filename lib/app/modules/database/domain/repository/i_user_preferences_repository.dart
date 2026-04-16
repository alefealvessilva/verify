import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';
import 'package:verify/app/modules/database/domain/errors/user_preferences_error.dart';

abstract class IUserPreferencesRepository {
  // User Preferences
  Future<ResultDart<Unit, UserPreferencesError>> saveUserThemePreference({
    required ThemeMode themeMode,
  });
  Future<ResultDart<Unit, UserPreferencesError>> updateUserThemePreference({
    required ThemeMode themeMode,
  });
  Future<ResultDart<ThemeMode, UserPreferencesError>> readUserThemePreference();
  Future<ResultDart<Unit, UserPreferencesError>> deleteUserThemePreference();
}
