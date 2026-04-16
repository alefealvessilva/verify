import 'package:result_dart/result_dart.dart';
import 'package:verify/app/modules/database/domain/errors/user_preferences_error.dart';
import 'package:verify/app/modules/database/domain/repository/i_user_preferences_repository.dart';

abstract class RemoveUserThemeModePreferenceUseCase {
  Future<ResultDart<Unit, UserPreferencesError>> call();
}

class RemoveUserThemeModePreferenceUseCaseImpl
    implements RemoveUserThemeModePreferenceUseCase {
  final IUserPreferencesRepository _userPreferencesRepository;

  RemoveUserThemeModePreferenceUseCaseImpl(this._userPreferencesRepository);
  @override
  Future<ResultDart<Unit, UserPreferencesError>> call() async {
    return await _userPreferencesRepository.deleteUserThemePreference();
  }
}
