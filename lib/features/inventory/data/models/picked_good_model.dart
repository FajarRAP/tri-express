import '../../domain/entities/picked_good_entity.dart';
import 'customer_model.dart';
import 'warehouse_model.dart';

class PickedGoodModel extends PickedGoodEntity {
  const PickedGoodModel({
    required super.id,
    required super.receiptNumber,
    required super.invoiceNumber,
    required super.name,
    required super.transportMode,
    required super.totalItem,
    required super.customer,
    required super.origin,
    required super.destination,
    required super.allUniqueCodes,
    required super.uniqueCodes,
    required super.deliveryCode,
    required super.note,
    required super.photoUrl,
    required super.deliveredAt,
  });

  factory PickedGoodModel.fromJson(Map<String, dynamic> json) {
    final units = List.from(json['units']);
    final allUnits = List.from(json['units_all']);

    return PickedGoodModel(
      id: '${json['receipt']['id']}',
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
      allUniqueCodes: allUnits.map((e) => '${e['unique_code']}').toList(),
      uniqueCodes: units.map((e) => '${e['unique_code']}').toList(),
      deliveryCode: json['delivery_code'],
      note: json['note'],
      photoUrl: json['photo_url'],
      deliveredAt: DateTime.parse(json['delivery_date']),
    );
  }

  PickedGoodEntity toEntity() {
    return PickedGoodEntity(
      id: id,
      receiptNumber: receiptNumber,
      invoiceNumber: invoiceNumber,
      name: name,
      transportMode: transportMode,
      totalItem: totalItem,
      customer: customer,
      origin: origin,
      destination: destination,
      allUniqueCodes: allUniqueCodes,
      uniqueCodes: uniqueCodes,
      deliveryCode: deliveryCode,
      note: note,
      photoUrl: photoUrl,
      deliveredAt: deliveredAt,
    );
  }
}
