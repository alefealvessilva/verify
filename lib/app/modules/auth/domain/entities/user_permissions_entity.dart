class UserPermissionsEntity {
  final bool canViewBB;
  final bool canViewSicoob;

  const UserPermissionsEntity({
    this.canViewBB = false,
    this.canViewSicoob = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'canViewBB': canViewBB,
      'canViewSicoob': canViewSicoob,
    };
  }

  factory UserPermissionsEntity.fromMap(Map<String, dynamic> map) {
    return UserPermissionsEntity(
      canViewBB: map['canViewBB'] ?? false,
      canViewSicoob: map['canViewSicoob'] ?? false,
    );
  }
}
