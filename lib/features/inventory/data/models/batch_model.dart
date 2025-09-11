import '../../domain/entities/batch_entity.dart';
import 'good_model.dart';
import 'warehouse_model.dart';

class BatchModel extends BatchEntity {
  const BatchModel({
    required super.id,
    required super.name,
    required super.status,
    required super.transportMode,
    required super.trackingNumber,
    required super.goods,
    required super.origin,
    required super.destination,
    required super.sendAt,
  });

  BatchEntity toEntity() {
    return BatchEntity(
      id: id,
      name: name,
      status: status,
      transportMode: transportMode,
      trackingNumber: trackingNumber,
      goods: goods,
      origin: origin,
      destination: destination,
      sendAt: sendAt,
    );
  }

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    final goods = List<Map<String, dynamic>>.from(json['shipment_items'] ?? []);

    return BatchModel(
      id: '${json['id']}',
      name: json['batch_code'],
      status: json['status_label'],
      transportMode: json['type_label'],
      trackingNumber: json['tracking_number'],
      goods: goods.map(GoodModel.fromJson).toList(),
      origin: WarehouseModel.fromJson(json['warehouse']),
      destination: WarehouseModel.fromJson(json['next_warehouse']),
      sendAt: DateTime.parse(json['shipment_date']),
    );
  }
}
