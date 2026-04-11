// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OnboardingStore on OnboardingStoreBase, Store {
  Computed<bool>? _$canContinueComputed;

  @override
  bool get canContinue =>
      (_$canContinueComputed ??= Computed<bool>(() => super.canContinue,
              name: 'OnboardingStoreBase.canContinue'))
          .value;

  late final _$loadingAtom =
      Atom(name: 'OnboardingStoreBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$isGestorAtom =
      Atom(name: 'OnboardingStoreBase.isGestor', context: context);

  @override
  bool get isGestor {
    _$isGestorAtom.reportRead();
    return super.isGestor;
  }

  @override
  set isGestor(bool value) {
    _$isGestorAtom.reportWrite(value, super.isGestor, () {
      super.isGestor = value;
    });
  }

  late final _$groupNameAtom =
      Atom(name: 'OnboardingStoreBase.groupName', context: context);

  @override
  String get groupName {
    _$groupNameAtom.reportRead();
    return super.groupName;
  }

  @override
  set groupName(String value) {
    _$groupNameAtom.reportWrite(value, super.groupName, () {
      super.groupName = value;
    });
  }

  late final _$inviteCodeAtom =
      Atom(name: 'OnboardingStoreBase.inviteCode', context: context);

  @override
  String get inviteCode {
    _$inviteCodeAtom.reportRead();
    return super.inviteCode;
  }

  @override
  set inviteCode(String value) {
    _$inviteCodeAtom.reportWrite(value, super.inviteCode, () {
      super.inviteCode = value;
    });
  }

  late final _$OnboardingStoreBaseActionController =
      ActionController(name: 'OnboardingStoreBase', context: context);

  @override
  void setGestor(bool value) {
    final _$actionInfo = _$OnboardingStoreBaseActionController.startAction(
        name: 'OnboardingStoreBase.setGestor');
    try {
      return super.setGestor(value);
    } finally {
      _$OnboardingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setGroupName(String value) {
    final _$actionInfo = _$OnboardingStoreBaseActionController.startAction(
        name: 'OnboardingStoreBase.setGroupName');
    try {
      return super.setGroupName(value);
    } finally {
      _$OnboardingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setInviteCode(String value) {
    final _$actionInfo = _$OnboardingStoreBaseActionController.startAction(
        name: 'OnboardingStoreBase.setInviteCode');
    try {
      return super.setInviteCode(value);
    } finally {
      _$OnboardingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$OnboardingStoreBaseActionController.startAction(
        name: 'OnboardingStoreBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$OnboardingStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
isGestor: ${isGestor},
groupName: ${groupName},
inviteCode: ${inviteCode},
canContinue: ${canContinue}
    ''';
  }
}
