import 'package:verify/app/modules/auth/infra/datasource/profile_datasource.dart';
import 'package:verify/app/modules/auth/infra/models/tenant_model.dart';
import 'package:verify/app/modules/auth/infra/models/user_permissions_model.dart';

abstract class TenantUseCases {
  Future<TenantModel> createTenant(String name, String adminId);
  Future<void> joinTenant(String inviteCode, String userId);
  Future<void> approveMember(String userId, UserPermissions permissions);
  Future<void> removeMember(String userId);
}

class TenantUseCasesImpl implements TenantUseCases {
  final ProfileDataSource _profileDataSource;

  TenantUseCasesImpl(this._profileDataSource);

  @override
  Future<TenantModel> createTenant(String name, String adminId) {
    return _profileDataSource.createTenant(name, adminId);
  }

  @override
  Future<void> joinTenant(String inviteCode, String userId) async {
    final tenant = await _profileDataSource.getTenantByInviteCode(inviteCode);
    return _profileDataSource.joinTenant(tenant.id, userId);
  }

  @override
  Future<void> approveMember(String userId, UserPermissions permissions) {
    return _profileDataSource.approveMember(userId, permissions);
  }

  @override
  Future<void> removeMember(String userId) {
    return _profileDataSource.removeMember(userId);
  }
}
