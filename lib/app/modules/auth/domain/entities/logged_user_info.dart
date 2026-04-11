import 'package:verify/app/modules/auth/domain/entities/user_permissions_entity.dart';

class LoggedUserInfoEntity {
  final String id;
  final String name;
  final String email;
  final bool emailVerified;
  final String? tenantId;
  final String role;
  final String status;
  final UserPermissionsEntity permissions;

  LoggedUserInfoEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerified,
    this.tenantId,
    this.role = 'none',
    this.status = 'none',
    this.permissions = const UserPermissionsEntity(),
  });
}
