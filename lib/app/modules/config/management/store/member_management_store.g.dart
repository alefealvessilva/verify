// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_management_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MemberManagementStore on MemberManagementStoreBase, Store {
  late final _$loadingAtom =
      Atom(name: 'MemberManagementStoreBase.loading', context: context);

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

  late final _$membersAtom =
      Atom(name: 'MemberManagementStoreBase.members', context: context);

  @override
  ObservableList<UserModel> get members {
    _$membersAtom.reportRead();
    return super.members;
  }

  @override
  set members(ObservableList<UserModel> value) {
    _$membersAtom.reportWrite(value, super.members, () {
      super.members = value;
    });
  }

  late final _$MemberManagementStoreBaseActionController =
      ActionController(name: 'MemberManagementStoreBase', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$MemberManagementStoreBaseActionController
        .startAction(name: 'MemberManagementStoreBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$MemberManagementStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMembers(List<UserModel> value) {
    final _$actionInfo = _$MemberManagementStoreBaseActionController
        .startAction(name: 'MemberManagementStoreBase.setMembers');
    try {
      return super.setMembers(value);
    } finally {
      _$MemberManagementStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeMember(String userId) {
    final _$actionInfo = _$MemberManagementStoreBaseActionController
        .startAction(name: 'MemberManagementStoreBase.removeMember');
    try {
      return super.removeMember(userId);
    } finally {
      _$MemberManagementStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
members: ${members}
    ''';
  }
}
