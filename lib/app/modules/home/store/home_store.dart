import 'package:mobx/mobx.dart';
import 'package:verify/app/shared/services/pix_services/models/verify_pix_model.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  @observable
  int selectedAccountCard = 0;

  @observable
  int visibleCardIndex = 0;

  @observable
  ObservableList<String> cardOrder = ObservableList<String>.of(['sicoob', 'bancoDoBrasil']);

  @observable
  ObservableList<VerifyPixModel> transactions = ObservableList<VerifyPixModel>();

  @observable
  bool isLoadingTransactions = false;

  @computed
  double get totalReceivedCalculated {
    double total = 0;
    for (var t in filteredTransactions) {
      total += t.value;
    }
    return total;
  }

  @computed
  List<VerifyPixModel> get filteredTransactions {
    if (searchQuery.isEmpty) return transactions.toList();
    return transactions.where((t) {
      return t.clientName.toLowerCase().contains(searchQuery.toLowerCase()) || 
             (t.paymentClientInfo?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  @computed
  bool get isSicoobActive {
    if (cardOrder.isEmpty) return false;
    final activeId = cardOrder[visibleCardIndex % cardOrder.length];
    return activeId == 'sicoob';
  }

  @computed
  bool get firstAccountSelected => visibleCardIndex == 0;

  @action
  void updateOrderBasedOnFavorites(String favoriteId) {
    if (cardOrder.contains(favoriteId)) {
      cardOrder.remove(favoriteId);
      cardOrder.insert(0, favoriteId);
    }
  }

  @action
  void setVisibleCardIndex(int index) {
    if (visibleCardIndex != index) {
      visibleCardIndex = index;
    }
  }

  @action
  void setTransactions(List<VerifyPixModel> list) {
    transactions = ObservableList<VerifyPixModel>.of(list);
    isLoadingTransactions = false;
  }

  @action
  void setIsLoadingTransactions(bool value) {
    isLoadingTransactions = value;
    if (value) transactions.clear();
  }

  @computed
  bool get secondAccountSelected => selectedAccountCard == 1;

  @action
  void setSelectedAccountCard(int selectedCard) {
    selectedAccountCard = selectedCard;
  }

  @action
  void setCardOrder(List<String> newOrder) {
    cardOrder = ObservableList<String>.of(newOrder);
  }

  @observable
  int selectedFilter = 0; // 0: Hoje, 1: Ontem, 2: Semana

  @action
  void setSelectedFilter(int filter) {
    selectedFilter = filter;
  }

  @observable
  String searchQuery = '';

  @observable
  double totalReceived = 0.0; // Mantido para compatibilidade temporária se necessário

  @observable
  bool isLoadingBalance = false;

  @action
  void setIsLoadingBalance(bool value) {
    isLoadingBalance = value;
  }

  @action
  void setTotalReceived(double value) {
    totalReceived = value;
    isLoadingBalance = false;
  }

  @action
  void setSearchQuery(String value) {
    searchQuery = value;
  }

  @action
  void reorderCards(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final item = cardOrder.removeAt(oldIndex);
    cardOrder.insert(newIndex, item);
  }
}
