import '../../../inventory/domain/entities/warehouse_entity.dart';

class UserEntity {
  const UserEntity({
    required this.id,
    this.warehouseId,
    this.avatarUrl,
    required this.email,
    required this.name,
    this.phoneNumber,
    required this.roles,
    required this.warehouse,
  });

  final String id;
  final String? warehouseId;
  final String? avatarUrl;
  final String email;
  final String name;
  final String? phoneNumber;
  final List<String> roles;
  final WarehouseEntity? warehouse;
}
