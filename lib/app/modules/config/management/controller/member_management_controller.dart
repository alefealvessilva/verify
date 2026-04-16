import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:verify/app/modules/auth/domain/usecase/tenant_usecases.dart';
import 'package:verify/app/modules/auth/infra/datasource/i_profile_datasource.dart';
import 'package:verify/app/modules/auth/infra/models/user_permissions_model.dart';
import 'package:verify/app/modules/config/management/store/member_management_store.dart';

class MemberManagementController {
  final MemberManagementStore _store;
  final TenantUseCases _tenantUseCases;
  final IProfileDataSource _profileDataSource;

  MemberManagementController(
      this._store, this._tenantUseCases, this._profileDataSource);

  Future<void> loadMembers(String tenantId) async {
    _store.setLoading(true);
    try {
      final members = await _profileDataSource.getTenantMembers(tenantId);
      _store.setMembers(members);
    } catch (e) {
      debugPrint('Error loading members: $e');
    } finally {
      _store.setLoading(false);
    }
  }

  Future<void> approveMember(String userId, UserPermissions permissions) async {
    try {
      await _tenantUseCases.approveMember(userId, permissions);
      // Refresh local list or update item
      final index = _store.members.indexWhere((m) => m.id == userId);
      if (index != -1) {
        _store.members[index] = _store.members[index].copyWith(
          status: 'approved',
          permissions: permissions,
        );
      }
    } catch (e) {
      debugPrint('Error approving member: $e');
    }
  }

  Future<void> removeMember(String userId) async {
    try {
      await _tenantUseCases.removeMember(userId);
      _store.removeMember(userId);
    } catch (e) {
      debugPrint('Error removing member: $e');
    }
  }
}
