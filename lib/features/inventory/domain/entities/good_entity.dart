import 'package:equatable/equatable.dart';

import 'customer_entity.dart';
import 'warehouse_entity.dart';

class GoodEntity extends Equatable {
  const GoodEntity({
    required this.id,
    required this.receiptNumber,
    required this.invoiceNumber,
    required this.name,
    required this.statusLabel,
    required this.transportMode,
    required this.status,
    required this.totalItem,
    required this.customer,
    required this.origin,
    required this.destination,
    required this.allUniqueCodes,
    required this.uniqueCodes,
  });

  final String id;
  final String receiptNumber;
  final String invoiceNumber;
  final String name;
  final String? statusLabel;
  final String transportMode;
  final int? status;
  final int totalItem;
  final CustomerEntity customer;
  final WarehouseEntity origin;
  final WarehouseEntity destination;
  final List<String> allUniqueCodes;
  final List<String> uniqueCodes;

  @override
  List<Object?> get props => [
        id,
        receiptNumber,
        invoiceNumber,
        name,
        statusLabel,
        transportMode,
        status,
        totalItem,
        customer,
        origin,
        destination,
        allUniqueCodes,
        uniqueCodes,
      ];
}
