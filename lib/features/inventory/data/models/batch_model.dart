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
    required super.totalAllUnits,
    required super.goods,
    required super.origin,
    required super.destination,
    required super.deliveryAt,
    required super.estimateAt,
    required super.receiveAt,
    required super.shipmentAt,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    final goods = List<Map<String, dynamic>>.from(json['items'] ?? []);

    return BatchModel(
      id: '${json['shipment_id']}',
      name: json['batch_code'],
      status: json['status_label'],
      transportMode: json['type_label'],
      trackingNumber: json['tracking_number'],
      totalAllUnits: json['total_units'],
      goods: goods.map((e) => GoodModel.fromJson(e).toEntity()).toList(),
      origin: WarehouseModel.fromJson(json['warehouse']).toEntity(),
      destination: WarehouseModel.fromJson(json['next_warehouse']).toEntity(),
      deliveryAt: DateTime.parse(json['delivery_date']),
      estimateAt: DateTime.parse(json['estimate_date']),
      receiveAt: DateTime.parse(json['receive_date']),
      shipmentAt: DateTime.parse(json['shipment_date']),
    );
  }

  BatchEntity toEntity() {
    return BatchEntity(
      id: id,
      name: name,
      status: status,
      transportMode: transportMode,
      trackingNumber: trackingNumber,
      totalAllUnits: totalAllUnits,
      goods: goods,
      origin: origin,
      destination: destination,
      deliveryAt: deliveryAt,
      estimateAt: estimateAt,
      receiveAt: receiveAt,
      shipmentAt: shipmentAt,
    );
  }
}
