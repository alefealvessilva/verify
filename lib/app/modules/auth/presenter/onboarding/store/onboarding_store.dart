import 'package:mobx/mobx.dart';

part 'onboarding_store.g.dart';

class OnboardingStore = OnboardingStoreBase with _$OnboardingStore;

abstract class OnboardingStoreBase with Store {
  @observable
  bool loading = false;

  @observable
  bool isGestor = true;

  @observable
  String groupName = '';

  @observable
  String inviteCode = '';

  @computed
  bool get canContinue {
    if (isGestor) {
      return groupName.trim().length >= 3;
    } else {
      return inviteCode.trim().length == 6;
    }
  }

  @action
  void setGestor(bool value) => isGestor = value;

  @action
  void setGroupName(String value) => groupName = value;

  @action
  void setInviteCode(String value) => inviteCode = value;

  @action
  void setLoading(bool value) => loading = value;
}
