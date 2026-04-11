import 'package:verify/app/modules/auth/domain/entities/logged_user_entity.dart';
import 'package:verify/app/modules/auth/domain/entities/logged_user_info.dart';
import 'package:verify/app/modules/auth/infra/models/user_permissions_model.dart';

class UserModel extends LoggedUserEntity implements LoggedUserInfoEntity {
  @override
  final String? tenantId;
  @override
  final String role;
  @override
  final String status;
  @override
  final UserPermissions permissions;

  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.emailVerified,
    this.tenantId,
    this.role = 'none',
    this.status = 'none',
    this.permissions = const UserPermissions(),
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        emailVerified,
        tenantId,
        role,
        status,
        permissions,
      ];

  LoggedUserEntity toLoggedUser() => this;

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    bool? emailVerified,
    String? tenantId,
    String? role,
    String? status,
    UserPermissions? permissions,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      emailVerified: emailVerified ?? this.emailVerified,
      tenantId: tenantId ?? this.tenantId,
      role: role ?? this.role,
      status: status ?? this.status,
      permissions: permissions ?? this.permissions,
    );
  }
}
