import '../../domain/entities/batch_entity.dart';
import 'good_model.dart';
import 'warehouse_model.dart';

class BatchModel extends BatchEntity {
  const BatchModel({
    required super.id,
    required super.name,
    required super.statusLabel,
    required super.transportMode,
    required super.trackingNumber,
    required super.status,
    required super.receivedUnits,
    required super.preparedUnits,
    required super.deliveredUnits,
    required super.totalAllUnits,
    required super.goods,
    required super.origin,
    required super.destination,
    required super.deliveredAt,
    required super.estimateAt,
    required super.receivedAt,
    required super.shippedAt,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    final goods = List<Map<String, dynamic>>.from(json['items'] ?? []);
    final goodEntities =
        goods.map((e) => GoodModel.fromJson(e).toEntity()).toList();

    return BatchModel(
      id: '${json['shipment_id']}',
      name: json['batch_code'],
      statusLabel: json['status_label'],
      transportMode: json['type_label'],
      trackingNumber: json['tracking_number'],
      status: json['status'],
      receivedUnits: json['receive_qty'] ?? 0,
      preparedUnits: json['prepare_qty'] ?? 0,
      deliveredUnits: json['delivery_qty'] ?? 0,
      totalAllUnits: json['total_units'] ??
          goodEntities.fold<int>(0, (prev, e) => prev + e.totalItem),
      goods: goodEntities,
      origin: WarehouseModel.fromJson(json['warehouse']).toEntity(),
      destination: WarehouseModel.fromJson(json['next_warehouse']).toEntity(),
      deliveredAt: json['delivery_date'] == null || json['delivery_date'] == ''
          ? null
          : DateTime.parse(json['delivery_date']),
      estimateAt: DateTime.parse(json['estimate_date']),
      receivedAt: json['receive_date'] == null || json['receive_date'] == ''
          ? null
          : DateTime.parse(json['receive_date']),
      shippedAt: DateTime.parse(json['shipment_date']),
    );
  }

  BatchEntity toEntity() {
    return BatchEntity(
      id: id,
      name: name,
      statusLabel: statusLabel,
      transportMode: transportMode,
      trackingNumber: trackingNumber,
      status: status,
      receivedUnits: receivedUnits,
      preparedUnits: preparedUnits,
      deliveredUnits: deliveredUnits,
      totalAllUnits: totalAllUnits,
      goods: goods,
      origin: origin,
      destination: destination,
      deliveredAt: deliveredAt,
      estimateAt: estimateAt,
      receivedAt: receivedAt,
      shippedAt: shippedAt,
    );
  }
}
