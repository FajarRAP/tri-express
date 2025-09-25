import '../../domain/entities/good_entity.dart';
import 'customer_model.dart';
import 'warehouse_model.dart';

class GoodModel extends GoodEntity {
  const GoodModel({
    required super.id,
    required super.receiptNumber,
    required super.invoiceNumber,
    required super.name,
    required super.transportMode,
    required super.totalItem,
    required super.customer,
    required super.origin,
    required super.destination,
    required super.uniqueCodes,
  });

  factory GoodModel.fromJson(Map<String, dynamic> json) {
    final units = List<Map<String, dynamic>>.from(json['units'] ?? []);

    return GoodModel(
      id: '${json['receipt_item']['id']}',
      receiptNumber: json['batch_tracking_number'],
      invoiceNumber: json['receipt']['invoice_code'],
      name: json['receipt_item']['item_name'],
      transportMode: json['receipt_item']['jalur_label'],
      totalItem: json['count'] ?? units.length,
      customer: CustomerModel.fromJson(json['receipt']['customer']).toEntity(),
      origin: WarehouseModel.fromJson(json['receipt']['warehouse']).toEntity(),
      destination:
          WarehouseModel.fromJson(json['receipt']['destination_warehouse'])
              .toEntity(),
      uniqueCodes: units.map((e) => '${e['unique_code']}').toList(),
    );
  }

  GoodEntity toEntity() {
    return GoodEntity(
      id: id,
      receiptNumber: receiptNumber,
      invoiceNumber: invoiceNumber,
      name: name,
      transportMode: transportMode,
      totalItem: totalItem,
      customer: customer,
      origin: origin,
      destination: destination,
      uniqueCodes: uniqueCodes,
    );
  }
}
