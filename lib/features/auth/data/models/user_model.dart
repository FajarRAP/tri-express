import '../../../inventory/data/models/warehouse_model.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    super.warehouseId,
    super.avatarUrl,
    required super.email,
    required super.name,
    required super.phoneNumber,
    required super.roles,
    super.warehouse,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roles = List<dynamic>.from(json['roles']);

    return UserModel(
      id: json['id'],
      warehouseId: json['gudang_id'],
      avatarUrl: json['avatar'],
      email: json['email'],
      name: json['name'],
      phoneNumber: json['no_telp'],
      roles: roles.map((role) => '${role['name']}').toList(),
      warehouse: WarehouseModel.fromJson(json['gudang']),
    );
  }

  UserEntity toEntity() => UserEntity(
        id: id,
        warehouseId: warehouseId,
        avatarUrl: avatarUrl,
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        roles: roles,
        warehouse: warehouse,
      );
}
