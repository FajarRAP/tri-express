import 'good_entity.dart';
import 'warehouse_entity.dart';

class BatchEntity {
  const BatchEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.transportMode,
    required this.trackingNumber,
    required this.totalAllUnits,
    required this.goods,
    required this.origin,
    required this.destination,
    required this.deliveryAt,
    required this.estimateAt,
    required this.receiveAt,
    required this.shipmentAt,
  });

  final String id;
  final String name;
  final String status;
  final String transportMode;
  final String trackingNumber;
  final int totalAllUnits;
  final List<GoodEntity> goods;
  final WarehouseEntity origin;
  final WarehouseEntity destination;
  final DateTime deliveryAt;
  final DateTime estimateAt;
  final DateTime? receiveAt;
  final DateTime shipmentAt;
}
