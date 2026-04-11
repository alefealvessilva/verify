// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on HomeStoreBase, Store {
  Computed<double>? _$totalReceivedCalculatedComputed;

  @override
  double get totalReceivedCalculated => (_$totalReceivedCalculatedComputed ??=
          Computed<double>(() => super.totalReceivedCalculated,
              name: 'HomeStoreBase.totalReceivedCalculated'))
      .value;
  Computed<List<VerifyPixModel>>? _$filteredTransactionsComputed;

  @override
  List<VerifyPixModel> get filteredTransactions =>
      (_$filteredTransactionsComputed ??= Computed<List<VerifyPixModel>>(
              () => super.filteredTransactions,
              name: 'HomeStoreBase.filteredTransactions'))
          .value;
  Computed<bool>? _$isSicoobActiveComputed;

  @override
  bool get isSicoobActive =>
      (_$isSicoobActiveComputed ??= Computed<bool>(() => super.isSicoobActive,
              name: 'HomeStoreBase.isSicoobActive'))
          .value;
  Computed<bool>? _$firstAccountSelectedComputed;

  @override
  bool get firstAccountSelected => (_$firstAccountSelectedComputed ??=
          Computed<bool>(() => super.firstAccountSelected,
              name: 'HomeStoreBase.firstAccountSelected'))
      .value;
  Computed<bool>? _$secondAccountSelectedComputed;

  @override
  bool get secondAccountSelected => (_$secondAccountSelectedComputed ??=
          Computed<bool>(() => super.secondAccountSelected,
              name: 'HomeStoreBase.secondAccountSelected'))
      .value;

  late final _$selectedAccountCardAtom =
      Atom(name: 'HomeStoreBase.selectedAccountCard', context: context);

  @override
  int get selectedAccountCard {
    _$selectedAccountCardAtom.reportRead();
    return super.selectedAccountCard;
  }

  @override
  set selectedAccountCard(int value) {
    _$selectedAccountCardAtom.reportWrite(value, super.selectedAccountCard, () {
      super.selectedAccountCard = value;
    });
  }

  late final _$visibleCardIndexAtom =
      Atom(name: 'HomeStoreBase.visibleCardIndex', context: context);

  @override
  int get visibleCardIndex {
    _$visibleCardIndexAtom.reportRead();
    return super.visibleCardIndex;
  }

  @override
  set visibleCardIndex(int value) {
    _$visibleCardIndexAtom.reportWrite(value, super.visibleCardIndex, () {
      super.visibleCardIndex = value;
    });
  }

  late final _$cardOrderAtom =
      Atom(name: 'HomeStoreBase.cardOrder', context: context);

  @override
  ObservableList<String> get cardOrder {
    _$cardOrderAtom.reportRead();
    return super.cardOrder;
  }

  @override
  set cardOrder(ObservableList<String> value) {
    _$cardOrderAtom.reportWrite(value, super.cardOrder, () {
      super.cardOrder = value;
    });
  }

  late final _$transactionsAtom =
      Atom(name: 'HomeStoreBase.transactions', context: context);

  @override
  ObservableList<VerifyPixModel> get transactions {
    _$transactionsAtom.reportRead();
    return super.transactions;
  }

  @override
  set transactions(ObservableList<VerifyPixModel> value) {
    _$transactionsAtom.reportWrite(value, super.transactions, () {
      super.transactions = value;
    });
  }

  late final _$isLoadingTransactionsAtom =
      Atom(name: 'HomeStoreBase.isLoadingTransactions', context: context);

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

  late final _$selectedFilterAtom =
      Atom(name: 'HomeStoreBase.selectedFilter', context: context);

  @override
  int get selectedFilter {
    _$selectedFilterAtom.reportRead();
    return super.selectedFilter;
  }

  @override
  set selectedFilter(int value) {
    _$selectedFilterAtom.reportWrite(value, super.selectedFilter, () {
      super.selectedFilter = value;
    });
  }

  late final _$searchQueryAtom =
      Atom(name: 'HomeStoreBase.searchQuery', context: context);

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

  late final _$totalReceivedAtom =
      Atom(name: 'HomeStoreBase.totalReceived', context: context);

  @override
  double get totalReceived {
    _$totalReceivedAtom.reportRead();
    return super.totalReceived;
  }

  @override
  set totalReceived(double value) {
    _$totalReceivedAtom.reportWrite(value, super.totalReceived, () {
      super.totalReceived = value;
    });
  }

  late final _$isLoadingBalanceAtom =
      Atom(name: 'HomeStoreBase.isLoadingBalance', context: context);

  @override
  bool get isLoadingBalance {
    _$isLoadingBalanceAtom.reportRead();
    return super.isLoadingBalance;
  }

  @override
  set isLoadingBalance(bool value) {
    _$isLoadingBalanceAtom.reportWrite(value, super.isLoadingBalance, () {
      super.isLoadingBalance = value;
    });
  }

  late final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase', context: context);

  @override
  void updateOrderBasedOnFavorites(String favoriteId) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.updateOrderBasedOnFavorites');
    try {
      return super.updateOrderBasedOnFavorites(favoriteId);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setVisibleCardIndex(int index) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setVisibleCardIndex');
    try {
      return super.setVisibleCardIndex(index);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTransactions(List<VerifyPixModel> list) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setTransactions');
    try {
      return super.setTransactions(list);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsLoadingTransactions(bool value) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setIsLoadingTransactions');
    try {
      return super.setIsLoadingTransactions(value);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedAccountCard(int selectedCard) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setSelectedAccountCard');
    try {
      return super.setSelectedAccountCard(selectedCard);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCardOrder(List<String> newOrder) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setCardOrder');
    try {
      return super.setCardOrder(newOrder);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedFilter(int filter) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setSelectedFilter');
    try {
      return super.setSelectedFilter(filter);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsLoadingBalance(bool value) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setIsLoadingBalance');
    try {
      return super.setIsLoadingBalance(value);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTotalReceived(double value) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setTotalReceived');
    try {
      return super.setTotalReceived(value);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchQuery(String value) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.setSearchQuery');
    try {
      return super.setSearchQuery(value);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reorderCards(int oldIndex, int newIndex) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.reorderCards');
    try {
      return super.reorderCards(oldIndex, newIndex);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedAccountCard: ${selectedAccountCard},
visibleCardIndex: ${visibleCardIndex},
cardOrder: ${cardOrder},
transactions: ${transactions},
isLoadingTransactions: ${isLoadingTransactions},
selectedFilter: ${selectedFilter},
searchQuery: ${searchQuery},
totalReceived: ${totalReceived},
isLoadingBalance: ${isLoadingBalance},
totalReceivedCalculated: ${totalReceivedCalculated},
filteredTransactions: ${filteredTransactions},
isSicoobActive: ${isSicoobActive},
firstAccountSelected: ${firstAccountSelected},
secondAccountSelected: ${secondAccountSelected}
    ''';
  }
}
