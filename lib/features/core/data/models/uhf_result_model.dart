import '../../domain/entities/uhf_result_entity.dart';

class UHFResultModel extends UHFResultEntity {
  UHFResultModel({
    required super.epcId,
    required super.tidId,
    required super.frequency,
    required super.rssi,
    required super.count,
  });

  factory UHFResultModel.fromJson(Map<String, dynamic> json) {
    return UHFResultModel(
      epcId: json['epc_id'] ?? '-',
      tidId: json['tid_id'] ?? '-',
      frequency: json['frequency'] ?? 0,
      rssi: json['rssi'] ?? 0,
      count: json['count'] ?? 1,
    );
  }

  UHFResultEntity toEntity() => UHFResultEntity(
        epcId: epcId,
        tidId: tidId,
        frequency: frequency,
        rssi: rssi,
        count: count,
      );
}
