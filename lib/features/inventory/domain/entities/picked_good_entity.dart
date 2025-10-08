import 'good_entity.dart';

class PickedGoodEntity extends GoodEntity {
  const PickedGoodEntity({
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
    required this.deliveryCode,
    required this.note,
    required this.photoUrl,
    required this.deliveredAt,
  });

  final String deliveryCode;
  final String note;
  final String photoUrl;
  final DateTime deliveredAt;
}
