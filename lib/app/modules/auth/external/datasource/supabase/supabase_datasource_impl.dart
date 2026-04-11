import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verify/app/modules/auth/domain/errors/auth_error.dart';
import 'package:verify/app/modules/auth/external/datasource/supabase/error_handler/supabase_auth_error_handler.dart';
import 'package:verify/app/modules/auth/infra/datasource/auth_datasource.dart';
import 'package:verify/app/modules/auth/infra/datasource/profile_datasource.dart';
import 'package:verify/app/modules/auth/infra/models/user_model.dart';
import 'package:verify/app/shared/error_registrator/register_log.dart';
import 'package:verify/app/shared/error_registrator/send_logs_to_web.dart';

class SupabaseAuthDataSourceImpl implements AuthDataSource {
  final SupabaseClient _supabase;
  final ProfileDataSource _profileDataSource;
  final SupabaseAuthErrorHandler _errorHandler;
  final RegisterLog _registerLog;
  final SendLogsToWeb _sendLogsToWeb;

  SupabaseAuthDataSourceImpl(
    this._supabase,
    this._profileDataSource,
    this._errorHandler,
    this._registerLog,
    this._sendLogsToWeb,
  );

  @override
  Future<UserModel?> currentUser() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session == null) return null;

      // Realizamos uma chamada ao servidor para validar o token com um timeout de segurança curto
      final response = await _supabase.auth.getUser().timeout(
            const Duration(seconds: 5),
            onTimeout: () =>
                throw TimeoutException('Supabase connection timeout'),
          );

      final user = response.user;

      if (user != null) {
        // Se o e-mail não estiver confirmado, retornamos um modelo básico
        // Isso evita travamentos de RLS na inicialização para usuários pendentes
        if (user.emailConfirmedAt == null) {
          return UserModel(
            id: user.id,
            email: user.email!,
            name: user.userMetadata?['full_name'] ?? '',
            emailVerified: false,
          );
        }

        return await _profileDataSource.getProfile(user.id);
      }
      return null;
    } on AuthException catch (e) {
      // Se o erro for de autenticação/sessão inválida, retornamos null
      if (e.message.toLowerCase().contains('invalid') ||
          e.message.toLowerCase().contains('not found')) {
        return null;
      }
      rethrow;
    } catch (e) {
      if (e is TimeoutException) {
        debugPrint('Supabase Auth timeout - possibly offline');
      } else {
        _sendLogsToWeb(e);
        _registerLog(e);
      }
      return null;
    }
  }

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user!;

      return await _profileDataSource.getProfile(user.id);
    } on AuthException catch (e) {
      final errorMessage = await _errorHandler(e);
      throw ErrorLoginEmail(message: errorMessage);
    } catch (e) {
      _sendLogsToWeb(e);
      _registerLog(e);
      throw Exception('Ocorreu um erro ao realizar o login. Tente novamente');
    }
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
      );

      if (!response) {
        throw ErrorGoogleLogin(
            message: 'Falha ao iniciar autenticação com Google');
      }

      throw UnimplementedError(
          'Login with Google needs specific platform integration for Supabase');
    } catch (e) {
      _sendLogsToWeb(e);
      _registerLog(e);
      throw ErrorGoogleLogin(
          message: 'Ocorreu um erro ao realizar o login com Google');
    }
  }

  @override
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      final user = response.user!;

      // Se a confirmação de e-mail estiver ligada, a sessão será nula.
      // Nesse caso, não podemos buscar o perfil pois o RLS bloqueará (não há token).
      if (response.session == null) {
        return UserModel(
          id: user.id,
          email: user.email!,
          name: user.userMetadata?['full_name'] ?? '',
          emailVerified: false,
        );
      }

      // Profile is created by DB trigger, but we try to fetch it
      // Added a small retry or delay if needed, but simple await should work if trigger is fast
      await Future.delayed(const Duration(milliseconds: 500));
      return await _profileDataSource.getProfile(user.id);
    } on AuthException catch (e) {
      final errorMessage = await _errorHandler(e);
      throw ErrorRegisterEmail(message: errorMessage);
    } catch (e) {
      _sendLogsToWeb(e);
      _registerLog(e);
      throw Exception(
          'Ocorreu um erro ao criar uma nova conta. Tente novamente');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      final errorMessage = await _errorHandler(e);
      throw ErrorLogout(message: errorMessage);
    } catch (e) {
      _sendLogsToWeb(e);
      _registerLog(e);
      throw Exception('Ocorreu um erro ao deslogar, tente novamente');
    }
  }

  @override
  Future<void> sendRecoverInstructions({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      final errorMessage = await _errorHandler(e);
      throw ErrorRecoverAccount(message: errorMessage);
    } catch (e) {
      _sendLogsToWeb(e);
      _registerLog(e);
      throw Exception(
          'Ocorreu um erro ao recuperar sua conta. Tente novamente');
    }
  }
}
