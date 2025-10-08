import 'customer_entity.dart';
import 'warehouse_entity.dart';

class GoodEntity {
  const GoodEntity({
    required this.id,
    required this.receiptNumber,
    required this.invoiceNumber,
    required this.name,
    required this.transportMode,
    required this.totalItem,
    required this.customer,
    required this.origin,
    required this.destination,
    required this.uniqueCodes,
  });

  final String id;
  final String receiptNumber;
  final String invoiceNumber;
  final String name;
  final String transportMode;
  final int totalItem;
  final CustomerEntity customer;
  final WarehouseEntity origin;
  final WarehouseEntity destination;
  final List<String> uniqueCodes;
}
