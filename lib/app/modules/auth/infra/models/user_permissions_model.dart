import 'package:verify/app/modules/auth/domain/entities/user_permissions_entity.dart';

class UserPermissions extends UserPermissionsEntity {
  const UserPermissions({
    super.canViewBB = false,
    super.canViewSicoob = false,
  });

  factory UserPermissions.fromMap(Map<String, dynamic> map) {
    return UserPermissions(
      canViewBB: map['canViewBB'] ?? false,
      canViewSicoob: map['canViewSicoob'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'canViewBB': canViewBB,
      'canViewSicoob': canViewSicoob,
    };
  }
}
