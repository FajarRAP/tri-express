import 'good_entity.dart';
import 'warehouse_entity.dart';

class BatchEntity {
  const BatchEntity({
    required this.id,
    required this.name,
    required this.statusLabel,
    required this.transportMode,
    required this.trackingNumber,
    required this.status,
    required this.receivedUnits,
    required this.preparedUnits,
    required this.deliveredUnits,
    required this.totalAllUnits,
    required this.goods,
    required this.origin,
    required this.destination,
    required this.deliveryAt,
    required this.estimateAt,
    required this.receivedAt,
    required this.shipmentAt,
  });

  final String id;
  final String name;
  final String statusLabel;
  final String transportMode;
  final String trackingNumber;
  final int status;
  final int receivedUnits;
  final int preparedUnits;
  final int deliveredUnits;
  final int totalAllUnits;
  final List<GoodEntity> goods;
  final WarehouseEntity origin;
  final WarehouseEntity destination;
  final DateTime? deliveryAt;
  final DateTime estimateAt;
  final DateTime? receivedAt;
  final DateTime shipmentAt;
}
