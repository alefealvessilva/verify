// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TimelineStore on TimelineStoreBase, Store {
  Computed<bool>? _$isSicoobSelectedComputed;

  @override
  bool get isSicoobSelected => (_$isSicoobSelectedComputed ??= Computed<bool>(
          () => super.isSicoobSelected,
          name: 'TimelineStoreBase.isSicoobSelected'))
      .value;

  late final _$isLoadingTransactionsAtom =
      Atom(name: 'TimelineStoreBase.isLoadingTransactions', context: context);

  @override
  bool get isLoadingTransactions {
    _$isLoadingTransactionsAtom.reportRead();
    return super.isLoadingTransactions;
  }

  @override
  set isLoadingTransactions(bool value) {
    _$isLoadingTransactionsAtom.reportWrite(value, super.isLoadingTransactions,
        () {
      super.isLoadingTransactions = value;
    });
  }

  late final _$transactionsAtom =
      Atom(name: 'TimelineStoreBase.transactions', context: context);

  @override
  List<VerifyPixModel> get transactions {
    _$transactionsAtom.reportRead();
    return super.transactions;
  }

  @override
  set transactions(List<VerifyPixModel> value) {
    _$transactionsAtom.reportWrite(value, super.transactions, () {
      super.transactions = value;
    });
  }

  late final _$searchQueryAtom =
      Atom(name: 'TimelineStoreBase.searchQuery', context: context);

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$selectedDateRangeAtom =
      Atom(name: 'TimelineStoreBase.selectedDateRange', context: context);

  @override
  DateTimeRange<DateTime> get selectedDateRange {
    _$selectedDateRangeAtom.reportRead();
    return super.selectedDateRange;
  }

  @override
  set selectedDateRange(DateTimeRange<DateTime> value) {
    _$selectedDateRangeAtom.reportWrite(value, super.selectedDateRange, () {
      super.selectedDateRange = value;
    });
  }

  late final _$selectedAccountIndexAtom =
      Atom(name: 'TimelineStoreBase.selectedAccountIndex', context: context);

  @override
  int get selectedAccountIndex {
    _$selectedAccountIndexAtom.reportRead();
    return super.selectedAccountIndex;
  }

  @override
  set selectedAccountIndex(int value) {
    _$selectedAccountIndexAtom.reportWrite(value, super.selectedAccountIndex,
        () {
      super.selectedAccountIndex = value;
    });
  }

  late final _$TimelineStoreBaseActionController =
      ActionController(name: 'TimelineStoreBase', context: context);

  @override
  void setIsLoadingTransactions(bool value) {
    final _$actionInfo = _$TimelineStoreBaseActionController.startAction(
        name: 'TimelineStoreBase.setIsLoadingTransactions');
    try {
      return super.setIsLoadingTransactions(value);
    } finally {
      _$TimelineStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTransactions(List<VerifyPixModel> value) {
    final _$actionInfo = _$TimelineStoreBaseActionController.startAction(
        name: 'TimelineStoreBase.setTransactions');
    try {
      return super.setTransactions(value);
    } finally {
      _$TimelineStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchQuery(String value) {
    final _$actionInfo = _$TimelineStoreBaseActionController.startAction(
        name: 'TimelineStoreBase.setSearchQuery');
    try {
      return super.setSearchQuery(value);
    } finally {
      _$TimelineStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedDateRange(DateTimeRange<DateTime> value) {
    final _$actionInfo = _$TimelineStoreBaseActionController.startAction(
        name: 'TimelineStoreBase.setSelectedDateRange');
    try {
      return super.setSelectedDateRange(value);
    } finally {
      _$TimelineStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedAccountIndex(int value) {
    final _$actionInfo = _$TimelineStoreBaseActionController.startAction(
        name: 'TimelineStoreBase.setSelectedAccountIndex');
    try {
      return super.setSelectedAccountIndex(value);
    } finally {
      _$TimelineStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoadingTransactions: ${isLoadingTransactions},
transactions: ${transactions},
searchQuery: ${searchQuery},
selectedDateRange: ${selectedDateRange},
selectedAccountIndex: ${selectedAccountIndex},
isSicoobSelected: ${isSicoobSelected}
    ''';
  }
}
