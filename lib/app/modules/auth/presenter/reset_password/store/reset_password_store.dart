import 'package:mobx/mobx.dart';

part 'reset_password_store.g.dart';

class ResetPasswordStore = ResetPasswordStoreBase with _$ResetPasswordStore;

abstract class ResetPasswordStoreBase with Store {
  @observable
  bool isValid = false;

  @observable
  bool isUpdating = false;

  @action
  void validateField(bool valid) {
    isValid = valid;
  }

  @action
  void updatingInProgress(bool updating) {
    isUpdating = updating;
  }
}
