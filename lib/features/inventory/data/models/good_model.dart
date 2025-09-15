import '../../domain/entities/good_entity.dart';

class GoodModel extends GoodEntity {
  const GoodModel({
    required super.id,
    required super.name,
    required super.receiptNumber,
  });

  GoodEntity toEntity() {
    return GoodEntity(
      id: id,
      name: name,
      receiptNumber: receiptNumber,
    );
  }

  factory GoodModel.fromJson(Map<String, dynamic> json) {
    return GoodModel(
      id: '${json['id']}',
      name: json['item_name'],
      receiptNumber: json['batch_tracking_number'],
    );
  }
}
