import 'package:verify/app/modules/auth/infra/models/tenant_model.dart';
import 'package:verify/app/modules/auth/infra/models/user_model.dart';
import 'package:verify/app/modules/auth/infra/models/user_permissions_model.dart';

abstract class IProfileDataSource {
  Future<UserModel> getProfile(String id);
  Future<void> updateProfile(UserModel user);
  Future<TenantModel> getTenant(String id);
  Future<TenantModel> createTenant(String name, String adminId);
  Future<TenantModel> getTenantByInviteCode(String inviteCode);
  Future<void> joinTenant(String tenantId, String userId);
  Future<List<UserModel>> getTenantMembers(String tenantId);
  Future<void> approveMember(String userId, UserPermissions permissions);
  Future<void> removeMember(String userId);
  Future<void> cancelJoinRequest(String userId);
}
