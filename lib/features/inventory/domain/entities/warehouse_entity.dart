class WarehouseEntity {
  const WarehouseEntity({
    required this.id,
    required this.countryId,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.phone,
    required this.warehouseCode,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String countryId;
  final String address;
  final String description;
  final String latitude;
  final String longitude;
  final String name;
  final String phone;
  final String warehouseCode;
  final DateTime createdAt;
  final DateTime updatedAt;
}
