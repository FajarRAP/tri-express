import 'customer_entity.dart';
import 'good_entity.dart';
import 'warehouse_entity.dart';

class LostGoodEntity extends GoodEntity {
  const LostGoodEntity({
    required super.id,
    required super.receiptNumber,
    required super.invoiceNumber,
    required super.name,
    super.statusLabel,
    required super.transportMode,
    super.status,
    required super.totalItem,
    required super.customer,
    required super.origin,
    required super.destination,
    required super.allUniqueCodes,
    required super.uniqueCodes,
    required this.currentWarehouse,
    required this.issuedAt,
  });

  LostGoodEntity copyWith({
    String? id,
    String? receiptNumber,
    String? invoiceNumber,
    String? name,
    String? statusLabel,
    String? transportMode,
    int? status,
    int? totalItem,
    CustomerEntity? customer,
    WarehouseEntity? origin,
    WarehouseEntity? destination,
    List<String>? allUniqueCodes,
    List<String>? uniqueCodes,
    WarehouseEntity? currentWarehouse,
    DateTime? issuedAt,
  }) {
    return LostGoodEntity(
      id: id ?? this.id,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      name: name ?? this.name,
      statusLabel: statusLabel ?? this.statusLabel,
      transportMode: transportMode ?? this.transportMode,
      status: status ?? this.status,
      totalItem: totalItem ?? this.totalItem,
      customer: customer ?? this.customer,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      allUniqueCodes: allUniqueCodes ?? this.allUniqueCodes,
      uniqueCodes: uniqueCodes ?? this.uniqueCodes,
      currentWarehouse: currentWarehouse ?? this.currentWarehouse,
      issuedAt: issuedAt ?? this.issuedAt,
    );
  }

  final WarehouseEntity currentWarehouse;
  final DateTime issuedAt;

  @override
  List<Object?> get props => [...super.props, currentWarehouse, issuedAt];
}
