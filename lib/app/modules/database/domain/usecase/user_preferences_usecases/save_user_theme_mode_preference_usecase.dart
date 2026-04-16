import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';
import 'package:verify/app/modules/database/domain/errors/user_preferences_error.dart';
import 'package:verify/app/modules/database/domain/repository/i_user_preferences_repository.dart';

abstract class SaveUserThemeModePreferenceUseCase {
  Future<ResultDart<Unit, UserPreferencesError>> call({
    required ThemeMode themeMode,
  });
}

class SaveUserThemeModePreferenceUseCaseImpl
    implements SaveUserThemeModePreferenceUseCase {
  final IUserPreferencesRepository _userPreferencesRepository;

  SaveUserThemeModePreferenceUseCaseImpl(this._userPreferencesRepository);
  @override
  Future<ResultDart<Unit, UserPreferencesError>> call({
    required ThemeMode themeMode,
  }) async {
    return await _userPreferencesRepository.saveUserThemePreference(
      themeMode: themeMode,
    );
  }
}
