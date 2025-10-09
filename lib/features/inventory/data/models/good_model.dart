import '../../domain/entities/good_entity.dart';
import 'customer_model.dart';
import 'warehouse_model.dart';

class GoodModel extends GoodEntity {
  const GoodModel({
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
  });

  factory GoodModel.fromJson(Map<String, dynamic> json) {
    final units = List<Map<String, dynamic>>.from(json['units'] ?? []);
    final allUnits = List<Map<String, dynamic>>.from(json['units_all'] ?? []);

    return GoodModel(
      id: '${json['receipt_item']['id']}',
      receiptNumber: json['batch_tracking_number'],
      invoiceNumber: json['receipt']['invoice_code'],
      name: json['receipt_item']['item_name'],
      statusLabel: json['status_label'],
      transportMode: json['receipt_item']['jalur_label'],
      status: json['status'],
      totalItem: json['count'] ?? units.length,
      customer: CustomerModel.fromJson(json['receipt']['customer']).toEntity(),
      origin: WarehouseModel.fromJson(json['receipt']['warehouse']).toEntity(),
      destination:
          WarehouseModel.fromJson(json['receipt']['destination_warehouse'])
              .toEntity(),
      allUniqueCodes: allUnits.map((e) => '${e['unique_code']}').toList(),
      uniqueCodes: units.map((e) => '${e['unique_code']}').toList(),
    );
  }

  GoodEntity toEntity() {
    return GoodEntity(
      id: id,
      receiptNumber: receiptNumber,
      invoiceNumber: invoiceNumber,
      name: name,
      statusLabel: statusLabel,
      transportMode: transportMode,
      status: status,
      totalItem: totalItem,
      customer: customer,
      origin: origin,
      destination: destination,
      allUniqueCodes: allUniqueCodes,
      uniqueCodes: uniqueCodes,
    );
  }
}
