import 'package:mobx/mobx.dart';
import 'package:verify/app/modules/auth/infra/models/user_model.dart';

part 'member_management_store.g.dart';

class MemberManagementStore = MemberManagementStoreBase
    with _$MemberManagementStore;

abstract class MemberManagementStoreBase with Store {
  @observable
  bool loading = false;

  @observable
  ObservableList<UserModel> members = ObservableList<UserModel>();

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setMembers(List<UserModel> value) {
    members.clear();
    members.addAll(value);
  }

  @action
  void removeMember(String userId) {
    members.removeWhere((m) => m.id == userId);
  }
}
