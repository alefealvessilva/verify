import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/app/core/admob_store.dart';
import 'package:verify/app/core/api_credentials_store.dart';
import 'package:verify/app/core/app_store.dart';
import 'package:verify/app/core/auth_store.dart';
import 'package:verify/app/modules/auth/presenter/login/controller/login_controller.dart';
import 'package:verify/app/modules/auth/presenter/login/store/login_store.dart';
import 'package:verify/app/modules/auth/presenter/login/view/login_page.dart';
import 'package:verify/app/modules/auth/presenter/recover/controller/recover_account_page_controller.dart';
import 'package:verify/app/modules/auth/presenter/recover/store/recover_account_store.dart';
import 'package:verify/app/modules/auth/presenter/recover/view/recover_account_page.dart';
import 'package:verify/app/modules/auth/presenter/onboarding/controller/onboarding_controller.dart';
import 'package:verify/app/modules/auth/presenter/onboarding/store/onboarding_store.dart';
import 'package:verify/app/modules/auth/presenter/onboarding/view/onboarding_page.dart';
import 'package:verify/app/modules/auth/presenter/register/controller/register_controller.dart';
import 'package:verify/app/modules/auth/presenter/register/store/register_store.dart';
import 'package:verify/app/modules/auth/presenter/register/view/register_page.dart';
import 'package:verify/app/modules/config/bb_settings/controller/bb_settings_page_controller.dart';
import 'package:verify/app/modules/config/bb_settings/store/bb_settings_store.dart';
import 'package:verify/app/modules/config/bb_settings/view/bb_settings_page.dart';
import 'package:verify/app/modules/config/settings/controller/settings_page_controller.dart';
import 'package:verify/app/modules/config/settings/view/settings_page.dart';
import 'package:verify/app/modules/config/management/controller/member_management_controller.dart';
import 'package:verify/app/modules/config/management/store/member_management_store.dart';
import 'package:verify/app/modules/config/management/view/member_management_page.dart';
import 'package:verify/app/modules/config/sicoob_settings/controller/sicoob_settings_page_controller.dart';
import 'package:verify/app/modules/auth/presenter/waiting/view/waiting_approval_page.dart';
import 'package:verify/app/modules/config/sicoob_settings/store/sicoob_settings_store.dart';
import 'package:verify/app/modules/config/sicoob_settings/view/sicoob_settings_page.dart';
import 'package:verify/app/modules/database/domain/usecase/bb_api_credentials_usecases/read_bb_api_credentials_usecase.dart';
import 'package:verify/app/modules/database/domain/usecase/bb_api_credentials_usecases/remove_bb_api_credentials_usecase.dart';
import 'package:verify/app/modules/database/domain/usecase/bb_api_credentials_usecases/save_bb_api_credentials_usecase.dart';
import 'package:verify/app/modules/database/domain/usecase/bb_api_credentials_usecases/update_bb_api_credentials_usecase.dart';
import 'package:verify/app/modules/database/domain/usecase/sicoob_api_credentials_usecases/read_sicoob_api_credentials_usecase.dart';
import 'package:verify/app/modules/database/domain/usecase/sicoob_api_credentials_usecases/remove_sicoob_api_credentials_usecase.dart';
import 'package:verify/app/modules/database/domain/usecase/sicoob_api_credentials_usecases/update_sicoob_api_credentials_usecase.dart';
import 'package:verify/app/modules/database/domain/usecase/user_preferences_usecases/remove_user_theme_mode_preference_usecase.dart';
import 'package:verify/app/modules/database/external/datasource/local_datasource_impl/local_api_credentials_data_source_impl.dart';
import 'package:verify/app/modules/database/utils/data_crypto.dart';
import 'package:verify/app/modules/home/controller/home_page_controller.dart';
import 'package:verify/app/modules/home/store/home_store.dart';
import 'package:verify/app/modules/home/view/home_page.dart';
import 'package:verify/app/modules/timeline/controller/timeline_controller.dart';
import 'package:verify/app/modules/timeline/store/timeline_store.dart';
import 'package:verify/app/modules/timeline/view/timeline_page.dart';
import 'package:verify/app/shared/error_registrator/register_log.dart';
import 'package:verify/app/shared/error_registrator/send_logs_to_web.dart';
import 'package:verify/app/modules/auth/domain/repositories/auth_repository.dart';
import 'package:verify/app/modules/auth/domain/usecase/get_logged_user_usecase.dart';
import 'package:verify/app/modules/auth/domain/usecase/login_with_email_usecase.dart';
import 'package:verify/app/modules/auth/domain/usecase/logout_usecase.dart';
import 'package:verify/app/modules/auth/domain/usecase/recover_account_usecase.dart';
import 'package:verify/app/modules/auth/domain/usecase/register_with_email_usecase.dart';
import 'package:verify/app/modules/auth/external/datasource/supabase/error_handler/supabase_auth_error_handler.dart';
import 'package:verify/app/modules/auth/external/datasource/supabase/supabase_datasource_impl.dart';
import 'package:verify/app/modules/auth/external/datasource/supabase/supabase_profile_datasource_impl.dart';
import 'package:verify/app/modules/auth/infra/datasource/auth_datasource.dart';
import 'package:verify/app/modules/auth/infra/datasource/profile_datasource.dart';
import 'package:verify/app/modules/auth/infra/repositories/auth_repository_impl.dart';
import 'package:verify/app/modules/auth/domain/usecase/tenant_usecases.dart';
import 'package:verify/app/modules/database/domain/repository/api_credentials_repository.dart';
import 'package:verify/app/modules/database/domain/repository/user_preferences_repository.dart';
import 'package:verify/app/modules/database/domain/usecase/sicoob_api_credentials_usecases/save_sicoob_api_credentials_usecase.dart';
import 'package:verify/app/modules/database/domain/usecase/user_preferences_usecases/read_user_theme_mode_preference_usecase.dart';
import 'package:verify/app/modules/database/domain/usecase/user_preferences_usecases/save_user_theme_mode_preference_usecase.dart';
import 'package:verify/app/modules/database/external/datasource/supabase/error_handler/supabase_database_error_handler.dart';
import 'package:verify/app/modules/database/external/datasource/supabase/supabase_api_credentials_datasource_impl.dart';
import 'package:verify/app/modules/database/external/datasource/local_datasource_impl/user_preferences_datasource_impl.dart';
import 'package:verify/app/modules/database/infra/datasource/cloud_api_credentials_datasource.dart';
import 'package:verify/app/modules/database/infra/datasource/local_api_credentials_datasource.dart';
import 'package:verify/app/modules/database/infra/datasource/user_preferences_datasource.dart';
import 'package:verify/app/modules/database/infra/repository/api_credentials_repository_impl.dart';
import 'package:verify/app/modules/database/infra/repository/user_preferences_repository_impl.dart';
import 'package:verify/app/shared/services/pix_services/bb_pix_api_service/bb_pix_api_service.dart';
import 'package:verify/app/shared/services/pix_services/bb_pix_api_service/error_handler/bb_pix_api_error_handler.dart';
import 'package:verify/app/shared/services/client_service/client_service.dart';
import 'package:verify/app/shared/services/client_service/dio_client_service.dart';
import 'package:verify/app/shared/services/pix_services/sicoob_pix_api_service/error_handler/sicoob_pix_api_error_handler.dart';
import 'package:verify/app/shared/services/pix_services/sicoob_pix_api_service/sicoob_pix_api_service.dart';
import 'package:verify/app/splash_screen_widget.dart';

class AppModule extends Module {
  final SharedPreferences sharedPreferences;

  AppModule(this.sharedPreferences);
  @override
  void binds(Injector i) {
    /// External Clients
    i.addInstance<SupabaseClient>(Supabase.instance.client);
    i.addInstance<ClientService>(DioClientService());
    i.addInstance<SharedPreferences>(sharedPreferences);

    ///Error Registers
    i.add<SendLogsToWeb>(SendLogsToDiscordChannel.new);
    i.add<RegisterLog>(RegisterLogImpl.new);

    /// Global Stores
    i.addInstance<AuthStore>(AuthStore());
    i.addInstance<AppStore>(
        AppStore(i.get<AuthStore>()));
    i.addInstance<ApiCredentialsStore>(ApiCredentialsStore());
    i.add<AdMobStore>(AdMobStore.new);

    /// Global Services
    //SicoobPix
    i.addSingleton<SicoobPixApiService>(SicoobPixApiServiceImpl.new);
    i.add<SicoobPixApiServiceErrorHandler>(
      SicoobPixApiServiceErrorHandler.new,
    );
    //BBPix
    i.addSingleton<BBPixApiService>(BBPixApiServiceImpl.new);
    i.add<BBPixApiServiceErrorHandler>(
      BBPixApiServiceErrorHandler.new,
    );
    //Banco do Brasil

    /// Auth
    // External
    // i.addInstance<GoogleSignIn>(GoogleSignIn());
    //Utils
    i.add<DataCrypto>(DataCryptoImpl.new);
    //DataSource
    i.addSingleton<ProfileDataSource>(SupabaseProfileDataSourceImpl.new);
    i.addSingleton<AuthDataSource>(SupabaseAuthDataSourceImpl.new);
    //Repository
    i.addSingleton<AuthRepository>(AuthRepositoryImpl.new);
    //Use Cases
    i.add<LoginWithEmailUseCase>(LoginWithEmailUseCaseImpl.new);
    i.add<GetLoggedUserUseCase>(GetLoggedUserUseCaseImpl.new);
    i.add<RemoveUserThemeModePreferenceUseCase>(
      RemoveUserThemeModePreferenceUseCaseImpl.new,
    );
    i.add<RegisterWithEmailUseCase>(
      RegisterWithEmailUseCaseImpl.new,
    );
    i.add<LogoutUseCase>(LogoutUseCaseImpl.new);
    i.add<RecoverAccountUseCase>(RecoverAccountUseCaseImpl.new);
    i.add<TenantUseCases>(TenantUseCasesImpl.new);
    //Error Handler
    i.add<SupabaseAuthErrorHandler>(
      SupabaseAuthErrorHandler.new,
    );

    ///Database
    i.add<SupabaseDatabaseErrorHandler>(
      SupabaseDatabaseErrorHandler.new,
    );
    //Datasources
    i.add<CloudApiCredentialsDataSource>(
      SupabaseApiCredentialsDataSourceImpl.new,
    );
    i.addInstance<FlutterSecureStorage>(const FlutterSecureStorage(
      aOptions: AndroidOptions(),
    ));
    i.add<LocalApiCredentialsDataSource>(
      LocalApiCredentialsDataSourceImpl.new,
    );
    i.add<UserPreferencesDataSource>(
      UserPreferencesLocalDataSourceImpl.new,
    );
    // Use Cases
    i.add<SaveUserThemeModePreferenceUseCase>(
      SaveUserThemeModePreferenceUseCaseImpl.new,
    );
    i.add<ReadUserThemeModePreferenceUseCase>(
      ReadUserThemeModePreferenceUseCaseImpl.new,
    );

    i.add<SaveSicoobApiCredentialsUseCase>(
      SaveSicoobApiCredentialsUseCaseImpl.new,
    );
    i.add<ReadSicoobApiCredentialsUseCase>(
      ReadSicoobApiCredentialsUseCaseImpl.new,
    );
    i.add<UpdateSicoobApiCredentialsUseCase>(
      UpdateSicoobApiCredentialsUseCaseImpl.new,
    );
    i.add<RemoveSicoobApiCredentialsUseCase>(
      RemoveSicoobApiCredentialsUseCaseImpl.new,
    );
    i.add<SaveBBApiCredentialsUseCase>(
      SaveBBApiCredentialsUseCaseImpl.new,
    );
    i.add<ReadBBApiCredentialsUseCase>(
      ReadBBApiCredentialsUseCaseImpl.new,
    );

    i.add<UpdateBBApiCredentialsUseCase>(
      UpdateBBApiCredentialsUseCaseImpl.new,
    );
    i.add<RemoveBBApiCredentialsUseCase>(
      RemoveBBApiCredentialsUseCaseImpl.new,
    );
    //Repositories
    i.add<ApiCredentialsRepository>(
      ApiCredentialsRepositoryImpl.new,
    );
    i.add<UserPreferencesRepository>(
      UserPreferencesRepositoryImpl.new,
    );
    i.addInstance<HomeStore>(HomeStore());
    i.add<HomePageController>(HomePageController.new);
    i.addInstance<LoginStore>(LoginStore());
    i.addInstance<RegisterStore>(RegisterStore());
    i.addInstance<RecoverAccountPageStore>(RecoverAccountPageStore());
    i.add<LoginController>(LoginController.new);
    i.add<RegisterController>(RegisterController.new);
    i.add<RecoverAccountPageController>(
      RecoverAccountPageController.new,
    );
    i.addInstance<OnboardingStore>(OnboardingStore());
    i.add<OnboardingController>(OnboardingController.new);
    i.addSingleton<SettingsPageController>(SettingsPageController.new);
    i.addSingleton<SicoobSettingsPageController>(
      SicoobSettingsPageController.new,
    );
    i.addSingleton<SicoobSettingsStore>(
      SicoobSettingsStore.new,
    );
    i.addSingleton<BBSettingsPageController>(
      BBSettingsPageController.new,
    );
    i.addSingleton<BBSettingsStore>(
      BBSettingsStore.new,
    );
    i.addInstance<MemberManagementStore>(MemberManagementStore());
    i.add<MemberManagementController>(MemberManagementController.new);
    i.addInstance<TimelineStore>(TimelineStore());
    i.add<TimelineController>(TimelineController.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (_) => const SplashScreen(),
    );
    r.child(
      '/settings',
      child: (_) => const SettingsPage(),
      transition: TransitionType.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
    r.child(
      '/settings/bb-settings',
      child: (_) => const BBSettingsPage(),
      transition: TransitionType.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
    r.child(
      '/settings/sicoob-settings',
      child: (_) => const SicoobSettingsPage(),
      transition: TransitionType.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
    r.child(
      '/auth/login',
      child: (_) => const LoginPage(),
      transition: TransitionType.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
    r.child(
      '/auth/register',
      child: (_) => const RegisterPage(),
      transition: TransitionType.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
    r.child(
      '/auth/recover',
      child: (_) => const RecoverAccountPage(),
      transition: TransitionType.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
    r.child(
      '/home',
      child: (_) => const HomePage(),
      transition: TransitionType.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
    r.child(
      '/auth/onboarding',
      child: (_) => const OnboardingPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      '/auth/waiting-approval',
      child: (_) => const WaitingApprovalPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      '/settings/management',
      child: (_) => const MemberManagementPage(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      '/timeline',
      child: (_) => const TimelinePage(),
      transition: TransitionType.fadeIn,
    );
    super.routes(r);
  }
}
