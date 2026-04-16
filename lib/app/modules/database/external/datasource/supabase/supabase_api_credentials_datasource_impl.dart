import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:verify/app/modules/database/domain/errors/api_credentials_error.dart';
import 'package:verify/app/modules/database/external/datasource/supabase/error_handler/supabase_database_error_handler.dart';
import 'package:verify/app/modules/database/infra/datasource/i_cloud_api_credentials_datasource.dart';
import 'package:verify/app/modules/database/infra/models/bb_api_credentials_model.dart';
import 'package:verify/app/modules/database/infra/models/sicoob_api_credentials_model.dart';
import 'package:verify/app/modules/database/utils/data_crypto.dart';
import 'package:verify/app/modules/database/utils/database_enums.dart';

class SupabaseApiCredentialsDataSourceImpl
    implements ICloudApiCredentialsDataSource {
  final SupabaseClient _supabase;
  final SupabaseDatabaseErrorHandler _errorHandler;
  final DataCrypto _dataCrypto;

  SupabaseApiCredentialsDataSourceImpl(
    this._supabase,
    this._errorHandler,
    this._dataCrypto,
  );

  String get _tableName => 'api_credentials';

  @override
  Future<void> saveBBApiCredentials({
    required String id, // This is now tenant_id
    required String applicationDeveloperKey,
    required String basicKey,
    required bool isFavorite,
  }) async {
    final key = _dataCrypto.generateKey(userId: id); // Key based on tenant_id
    final encryptedApplicationDeveloperKey = _dataCrypto.encrypt(
      plainText: applicationDeveloperKey,
      key: key,
    );
    final encryptedBasicKey = _dataCrypto.encrypt(
      plainText: basicKey,
      key: key,
    );
    final bbCredentials = BBApiCredentialsModel(
      applicationDeveloperKey: encryptedApplicationDeveloperKey,
      basicKey: encryptedBasicKey,
      isFavorite: isFavorite,
    );

    try {
      await _supabase.from(_tableName).upsert({
        'tenant_id': id,
        'type': DocumentName.bbApiCredential.name,
        'data': bbCredentials.toMap(),
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'tenant_id,type');
    } catch (e) {
      final errorMessage = await _errorHandler(e);
      throw ErrorSavingApiCredentials(message: errorMessage);
    }
  }

  @override
  Future<BBApiCredentialsModel?> readBBApiCredentials({
    required String id, // This is now tenant_id
  }) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select('data')
          .eq('tenant_id', id)
          .eq('type', DocumentName.bbApiCredential.name)
          .maybeSingle();

      if (response == null) return null;

      final data = response['data'] as Map<String, dynamic>;
      final key = _dataCrypto.generateKey(userId: id);

      return BBApiCredentialsModel(
        applicationDeveloperKey: _dataCrypto.decrypt(
          cipherText: data['applicationDeveloperKey'],
          key: key,
        ),
        basicKey: _dataCrypto.decrypt(
          cipherText: data['basicKey'],
          key: key,
        ),
        isFavorite: data['isFavorite'] ?? false,
      );
    } catch (e) {
      final errorMessage = await _errorHandler(e);
      throw ErrorReadingApiCredentials(message: errorMessage);
    }
  }

  @override
  Future<void> updateBBApiCredentials({
    required String id,
    required String applicationDeveloperKey,
    required String basicKey,
    required bool isFavorite,
  }) async {
    await saveBBApiCredentials(
      id: id,
      applicationDeveloperKey: applicationDeveloperKey,
      basicKey: basicKey,
      isFavorite: isFavorite,
    );
  }

  @override
  Future<void> deleteBBApiCredentials({
    required String id,
  }) async {
    try {
      await _supabase
          .from(_tableName)
          .delete()
          .eq('tenant_id', id)
          .eq('type', DocumentName.bbApiCredential.name);
    } catch (e) {
      final errorMessage = await _errorHandler(e);
      throw ErrorRemovingApiCredentials(message: errorMessage);
    }
  }

  @override
  Future<void> saveSicoobApiCredentials({
    required String id, // This is now tenant_id
    required String clientID,
    required String certificatePassword,
    required String certificateBase64String,
    required bool isFavorite,
  }) async {
    final key = _dataCrypto.generateKey(userId: id);
    final sicoobCredentials = SicoobApiCredentialsModel(
      clientID: _dataCrypto.encrypt(plainText: clientID, key: key),
      certificateBase64String:
          _dataCrypto.encrypt(plainText: certificateBase64String, key: key),
      certificatePassword:
          _dataCrypto.encrypt(plainText: certificatePassword, key: key),
      isFavorite: isFavorite,
    );

    try {
      await _supabase.from(_tableName).upsert({
        'tenant_id': id,
        'type': DocumentName.sicoobApiCredential.name,
        'data': sicoobCredentials.toMap(),
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'tenant_id,type');
    } catch (e) {
      final errorMessage = await _errorHandler(e);
      throw ErrorSavingApiCredentials(message: errorMessage);
    }
  }

  @override
  Future<SicoobApiCredentialsModel?> readSicoobApiCredentials({
    required String id, // This is now tenant_id
  }) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select('data')
          .eq('tenant_id', id)
          .eq('type', DocumentName.sicoobApiCredential.name)
          .maybeSingle();

      if (response == null) return null;

      final data = response['data'] as Map<String, dynamic>;
      final key = _dataCrypto.generateKey(userId: id);

      return SicoobApiCredentialsModel(
        clientID: _dataCrypto.decrypt(cipherText: data['clientID'], key: key),
        certificatePassword: _dataCrypto.decrypt(
            cipherText: data['certificatePassword'], key: key),
        certificateBase64String: _dataCrypto.decrypt(
            cipherText: data['certificateBase64String'], key: key),
        isFavorite: data['isFavorite'] ?? false,
      );
    } catch (e) {
      final errorMessage = await _errorHandler(e);
      throw ErrorReadingApiCredentials(message: errorMessage);
    }
  }

  @override
  Future<void> updateSicoobApiCredentials({
    required String id,
    required String clientID,
    required String certificatePassword,
    required String certificateBase64String,
    required bool isFavorite,
  }) async {
    await saveSicoobApiCredentials(
      id: id,
      clientID: clientID,
      certificatePassword: certificatePassword,
      certificateBase64String: certificateBase64String,
      isFavorite: isFavorite,
    );
  }

  @override
  Future<void> deleteSicoobApiCredentials({
    required String id,
  }) async {
    try {
      await _supabase
          .from(_tableName)
          .delete()
          .eq('tenant_id', id)
          .eq('type', DocumentName.sicoobApiCredential.name);
    } catch (e) {
      final errorMessage = await _errorHandler(e);
      throw ErrorRemovingApiCredentials(message: errorMessage);
    }
  }
}
