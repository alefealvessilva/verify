// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ResetPasswordStore on ResetPasswordStoreBase, Store {
  late final _$isValidAtom =
      Atom(name: 'ResetPasswordStoreBase.isValid', context: context);

  @override
  bool get isValid {
    _$isValidAtom.reportRead();
    return super.isValid;
  }

  @override
  set isValid(bool value) {
    _$isValidAtom.reportWrite(value, super.isValid, () {
      super.isValid = value;
    });
  }

  late final _$isUpdatingAtom =
      Atom(name: 'ResetPasswordStoreBase.isUpdating', context: context);

  @override
  bool get isUpdating {
    _$isUpdatingAtom.reportRead();
    return super.isUpdating;
  }

  @override
  set isUpdating(bool value) {
    _$isUpdatingAtom.reportWrite(value, super.isUpdating, () {
      super.isUpdating = value;
    });
  }

  late final _$ResetPasswordStoreBaseActionController =
      ActionController(name: 'ResetPasswordStoreBase', context: context);

  @override
  void validateField(bool valid) {
    final _$actionInfo = _$ResetPasswordStoreBaseActionController.startAction(
        name: 'ResetPasswordStoreBase.validateField');
    try {
      return super.validateField(valid);
    } finally {
      _$ResetPasswordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updatingInProgress(bool updating) {
    final _$actionInfo = _$ResetPasswordStoreBaseActionController.startAction(
        name: 'ResetPasswordStoreBase.updatingInProgress');
    try {
      return super.updatingInProgress(updating);
    } finally {
      _$ResetPasswordStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isValid: ${isValid},
isUpdating: ${isUpdating}
    ''';
  }
}
