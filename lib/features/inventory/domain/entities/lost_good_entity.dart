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

  final WarehouseEntity currentWarehouse;
  final DateTime issuedAt;

  @override
  List<Object?> get props => [...super.props, currentWarehouse, issuedAt];
}
