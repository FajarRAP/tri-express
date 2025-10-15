import '../../domain/entities/lost_good_entity.dart';
import 'customer_model.dart';
import 'warehouse_model.dart';

class LostGoodModel extends LostGoodEntity {
  const LostGoodModel({
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
    required super.currentWarehouse,
    required super.issuedAt,
  });

  factory LostGoodModel.fromJson(Map<String, dynamic> json) {
    final units = List<Map<String, dynamic>>.from(json['units'] ?? []);
    final allUnits = List<Map<String, dynamic>>.from(json['units_all'] ?? []);
    final good = Map<String, dynamic>.from(json['data']);
    final receiptItem = Map<String, dynamic>.from(good['receipt_item']);

    return LostGoodModel(
      id: '${receiptItem['id']}',
      receiptNumber: good['batch_tracking_number'],
      invoiceNumber: receiptItem['receipt']['invoice_code'],
      name: receiptItem['item_name'],
      statusLabel: good['status_label'],
      transportMode: receiptItem['jalur_label'],
      status: good['status'],
      totalItem: good['count'] ?? allUnits.length,
      customer:
          CustomerModel.fromJson(receiptItem['receipt']['customer']).toEntity(),
      origin: WarehouseModel.fromJson(receiptItem['receipt']['warehouse'])
          .toEntity(),
      destination: WarehouseModel.fromJson(
              receiptItem['receipt']['destination_warehouse'])
          .toEntity(),
      allUniqueCodes: allUnits.map((e) => '${e['unique_code']}').toList(),
      uniqueCodes: units.map((e) => '${e['unique_code']}').toList(),
      currentWarehouse:
          WarehouseModel.fromJson(good['current_warehouse']).toEntity(),
      issuedAt: DateTime.parse(receiptItem['receipt']['receipt_date']),
    );
  }

  factory LostGoodModel.fromJsonInventory(Map<String, dynamic> json) {
    final units = List<Map<String, dynamic>>.from(json['units'] ?? []);
    final allUnits = List<Map<String, dynamic>>.from(json['units_all'] ?? []);
    final receiptItem = Map<String, dynamic>.from(json['receipt_item']);
    final receipt = Map<String, dynamic>.from(receiptItem['receipt']);

    return LostGoodModel(
      id: '${receiptItem['id']}',
      receiptNumber: json['batch_tracking_number'],
      invoiceNumber: receipt['invoice_code'],
      name: receiptItem['item_name'],
      statusLabel: json['status_label'],
      transportMode: receiptItem['jalur_label'],
      status: json['status'],
      totalItem: json['count'] ?? allUnits.length,
      customer: CustomerModel.fromJson(receipt['customer']).toEntity(),
      origin: WarehouseModel.fromJson(receipt['warehouse']).toEntity(),
      destination:
          WarehouseModel.fromJson(receipt['destination_warehouse']).toEntity(),
      allUniqueCodes: allUnits.map((e) => '${e['unique_code']}').toList(),
      uniqueCodes: units.map((e) => '${e['unique_code']}').toList(),
      currentWarehouse:
          WarehouseModel.fromJson(json['current_warehouse']).toEntity(),
      issuedAt: DateTime.parse(receipt['receipt_date']),
    );
  }

  LostGoodEntity toEntity() {
    return LostGoodEntity(
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
      currentWarehouse: currentWarehouse,
      issuedAt: issuedAt,
    );
  }
}
