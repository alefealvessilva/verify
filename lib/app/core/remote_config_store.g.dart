// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RemoteConfigStore on _RemoteConfigStoreBase, Store {
  late final _$isMaintenanceAtom =
      Atom(name: '_RemoteConfigStoreBase.isMaintenance', context: context);

  @override
  bool get isMaintenance {
    _$isMaintenanceAtom.reportRead();
    return super.isMaintenance;
  }

  @override
  set isMaintenance(bool value) {
    _$isMaintenanceAtom.reportWrite(value, super.isMaintenance, () {
      super.isMaintenance = value;
    });
  }

  late final _$maintenanceMessageAtom =
      Atom(name: '_RemoteConfigStoreBase.maintenanceMessage', context: context);

  @override
  String get maintenanceMessage {
    _$maintenanceMessageAtom.reportRead();
    return super.maintenanceMessage;
  }

  @override
  set maintenanceMessage(String value) {
    _$maintenanceMessageAtom.reportWrite(value, super.maintenanceMessage, () {
      super.maintenanceMessage = value;
    });
  }

  late final _$needsUpdateAtom =
      Atom(name: '_RemoteConfigStoreBase.needsUpdate', context: context);

  @override
  bool get needsUpdate {
    _$needsUpdateAtom.reportRead();
    return super.needsUpdate;
  }

  @override
  set needsUpdate(bool value) {
    _$needsUpdateAtom.reportWrite(value, super.needsUpdate, () {
      super.needsUpdate = value;
    });
  }

  late final _$apkUrlAtom =
      Atom(name: '_RemoteConfigStoreBase.apkUrl', context: context);

  @override
  String? get apkUrl {
    _$apkUrlAtom.reportRead();
    return super.apkUrl;
  }

  @override
  set apkUrl(String? value) {
    _$apkUrlAtom.reportWrite(value, super.apkUrl, () {
      super.apkUrl = value;
    });
  }

  late final _$latestVersionAtom =
      Atom(name: '_RemoteConfigStoreBase.latestVersion', context: context);

  @override
  String get latestVersion {
    _$latestVersionAtom.reportRead();
    return super.latestVersion;
  }

  @override
  set latestVersion(String value) {
    _$latestVersionAtom.reportWrite(value, super.latestVersion, () {
      super.latestVersion = value;
    });
  }

  late final _$fetchConfigAsyncAction =
      AsyncAction('_RemoteConfigStoreBase.fetchConfig', context: context);

  @override
  Future<void> fetchConfig() {
    return _$fetchConfigAsyncAction.run(() => super.fetchConfig());
  }

  late final _$_checkUpdateStatusAsyncAction = AsyncAction(
      '_RemoteConfigStoreBase._checkUpdateStatus',
      context: context);

  @override
  Future<void> _checkUpdateStatus() {
    return _$_checkUpdateStatusAsyncAction
        .run(() => super._checkUpdateStatus());
  }

  late final _$_RemoteConfigStoreBaseActionController =
      ActionController(name: '_RemoteConfigStoreBase', context: context);

  @override
  void initRealtimeListeners() {
    final _$actionInfo = _$_RemoteConfigStoreBaseActionController.startAction(
        name: '_RemoteConfigStoreBase.initRealtimeListeners');
    try {
      return super.initRealtimeListeners();
    } finally {
      _$_RemoteConfigStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isMaintenance: ${isMaintenance},
maintenanceMessage: ${maintenanceMessage},
needsUpdate: ${needsUpdate},
apkUrl: ${apkUrl},
latestVersion: ${latestVersion}
    ''';
  }
}
