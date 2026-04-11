class TenantModel {
  final String id;
  final String name;
  final String inviteCode;

  TenantModel({
    required this.id,
    required this.name,
    required this.inviteCode,
  });

  factory TenantModel.fromMap(Map<String, dynamic> map) {
    return TenantModel(
      id: map['id'] as String,
      name: map['name'] as String,
      inviteCode: map['invite_code'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'invite_code': inviteCode,
      };

  @override
  String toString() {
    return 'TenantModel(id: $id, name: $name, inviteCode: $inviteCode)';
  }
}
