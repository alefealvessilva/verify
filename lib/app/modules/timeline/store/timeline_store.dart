import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:verify/app/shared/services/pix_services/models/verify_pix_model.dart';
import 'package:verify/app/shared/extensions/date_time.dart';

part 'timeline_store.g.dart';

class TimelineStore = TimelineStoreBase with _$TimelineStore;

abstract class TimelineStoreBase with Store {
  @observable
  bool isLoadingTransactions = false;

  @observable
  List<VerifyPixModel> transactions = [];

  @observable
  String searchQuery = '';

  @observable
  DateTimeRange selectedDateRange = DateTimeRange(
    start: DateTime.now().toBrazilianTimeZone(),
    end: DateTime.now().toBrazilianTimeZone(),
  );

  @observable
  int selectedAccountIndex = 0; // 0: Sicoob, 1: Banco do Brasil

  @computed
  bool get isSicoobSelected => selectedAccountIndex == 0;

  @action
  void setIsLoadingTransactions(bool value) => isLoadingTransactions = value;

  @action
  void setTransactions(List<VerifyPixModel> value) => transactions = value;

  @action
  void setSearchQuery(String value) => searchQuery = value;

  @action
  void setSelectedDateRange(DateTimeRange value) => selectedDateRange = value;

  @action
  void setSelectedAccountIndex(int value) => selectedAccountIndex = value;
}
