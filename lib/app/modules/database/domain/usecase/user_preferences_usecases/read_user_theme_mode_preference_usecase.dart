import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';
import 'package:verify/app/modules/database/domain/errors/user_preferences_error.dart';
import 'package:verify/app/modules/database/domain/repository/user_preferences_repository.dart';

abstract class ReadUserThemeModePreferenceUseCase {
  Future<ResultDart<ThemeMode, UserPreferencesError>> call();
}

class ReadUserThemeModePreferenceUseCaseImpl
    implements ReadUserThemeModePreferenceUseCase {
  final UserPreferencesRepository _userPreferencesRepository;

  ReadUserThemeModePreferenceUseCaseImpl(this._userPreferencesRepository);
  @override
  Future<ResultDart<ThemeMode, UserPreferencesError>> call() async {
    return await _userPreferencesRepository.readUserThemePreference();
  }
}
