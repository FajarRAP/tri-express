import '../../domain/entities/warehouse_entity.dart';

class WarehouseModel extends WarehouseEntity {
  const WarehouseModel({
    required super.id,
    required super.countryId,
    required super.address,
    required super.description,
    required super.latitude,
    required super.longitude,
    required super.name,
    required super.phone,
    required super.warehouseCode,
    required super.createdAt,
    required super.updatedAt,
  });

  WarehouseEntity toEntity() {
    return WarehouseEntity(
      id: id,
      countryId: countryId,
      address: address,
      description: description,
      latitude: latitude,
      longitude: longitude,
      name: name,
      phone: phone,
      warehouseCode: warehouseCode,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: json["id"],
      countryId: json["negara_id"],
      address: json["alamat"],
      description: json["keterangan"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      name: json["title"],
      phone: json["no_telp"],
      warehouseCode: json["kode"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}
