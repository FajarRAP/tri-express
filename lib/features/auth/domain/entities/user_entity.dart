class UserEntity {
  final String id;
  final String warehouseId;
  final String? avatarUrl;
  final String email;
  final String name;
  final String phoneNumber;
  final List<String> roles;

  const UserEntity({
    required this.id,
    required this.warehouseId,
    this.avatarUrl,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.roles,
  });
}
