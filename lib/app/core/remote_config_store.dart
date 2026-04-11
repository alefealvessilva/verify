import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobx/mobx.dart';

part 'remote_config_store.g.dart';

class RemoteConfigStore = _RemoteConfigStoreBase with _$RemoteConfigStore;

abstract class _RemoteConfigStoreBase with Store {
  final SupabaseClient _supabase;

  _RemoteConfigStoreBase(this._supabase);
  
  RealtimeChannel? _channel;

  @observable
  bool isMaintenance = false;

  @observable
  String maintenanceMessage = 'Estamos em manutenção para melhorias.';

  @observable
  bool needsUpdate = false;

  @observable
  String? apkUrl;

  @observable
  String latestVersion = '1.0.0';

  @action
  Future<void> fetchConfig() async {
    try {
      final response =
          await _supabase.from('remote_config').select();
      
      if (response.isNotEmpty) {
        final data = response.first;
        
        runInAction(() {
          // Conversão de tipo infalível
          isMaintenance = _parseBool(data['is_maintenance']);
          maintenanceMessage = data['maintenance_message'] ??
              'Estamos em manutenção para melhorias.';
          latestVersion = data['min_version'] ?? '1.0.0';
          apkUrl = data['apk_url'];
        });

        await _checkUpdateStatus();
      } else {
        debugPrint('RemoteConfigStore: No records found, using defaults.');
        runInAction(() {
          isMaintenance = false;
          needsUpdate = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching remote config: $e');
    }
  }

  @action
  void initRealtimeListeners() {
    _channel = _supabase
        .channel('public:remote_config')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'remote_config',
          callback: (payload) {
            try {
              final data = payload.newRecord;
              if (data.isNotEmpty) {
                runInAction(() {
                  // Conversão de tipo infalível
                  isMaintenance = _parseBool(data['is_maintenance']);
                  maintenanceMessage = data['maintenance_message'] ?? 'Estamos em manutenção para melhorias.';
                  latestVersion = data['min_version'] ?? '1.0.0';
                  apkUrl = data['apk_url'];
                });
                
                _checkUpdateStatus();
              }
            } catch (e) {
              debugPrint('Error in RemoteConfig Realtime callback: $e');
            }
          },
        )
        .subscribe();
  }

  void dispose() {
    _channel?.unsubscribe();
  }

  @action
  Future<void> _checkUpdateStatus() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      needsUpdate = _isVersionOlder(currentVersion, latestVersion);
    } catch (e) {
      print('Error checking update status: $e');
    }
  }

  bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }

  bool _isVersionOlder(String current, String latest) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> latestParts = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      int currentV = i < currentParts.length ? currentParts[i] : 0;
      int latestV = latestParts[i];

      if (currentV < latestV) return true;
      if (currentV > latestV) return false;
    }
    return false;
  }
}
