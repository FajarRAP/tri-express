import 'package:equatable/equatable.dart';

import 'good_entity.dart';
import 'warehouse_entity.dart';

class BatchEntity extends Equatable {
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
    required this.deliveredAt,
    required this.estimateAt,
    required this.receivedAt,
    required this.shippedAt,
  });

  BatchEntity copyWith({
    String? id,
    String? name,
    String? statusLabel,
    String? transportMode,
    String? trackingNumber,
    int? status,
    int? receivedUnits,
    int? preparedUnits,
    int? deliveredUnits,
    int? totalAllUnits,
    List<GoodEntity>? goods,
    WarehouseEntity? origin,
    WarehouseEntity? destination,
    DateTime? deliveredAt,
    DateTime? estimateAt,
    DateTime? receivedAt,
    DateTime? shippedAt,
  }) {
    return BatchEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      statusLabel: statusLabel ?? this.statusLabel,
      transportMode: transportMode ?? this.transportMode,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      status: status ?? this.status,
      receivedUnits: receivedUnits ?? this.receivedUnits,
      preparedUnits: preparedUnits ?? this.preparedUnits,
      deliveredUnits: deliveredUnits ?? this.deliveredUnits,
      totalAllUnits: totalAllUnits ?? this.totalAllUnits,
      goods: goods ?? this.goods,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      estimateAt: estimateAt ?? this.estimateAt,
      receivedAt: receivedAt ?? this.receivedAt,
      shippedAt: shippedAt ?? this.shippedAt,
    );
  }

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
  final DateTime? deliveredAt;
  final DateTime estimateAt;
  final DateTime? receivedAt;
  final DateTime shippedAt;

  @override
  List<Object?> get props => [
        id,
        name,
        statusLabel,
        transportMode,
        trackingNumber,
        status,
        receivedUnits,
        preparedUnits,
        deliveredUnits,
        totalAllUnits,
        goods,
        origin,
        destination,
        deliveredAt,
        estimateAt,
        receivedAt,
        shippedAt,
      ];
}
