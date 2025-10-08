import '../../domain/entities/timeline_entity.dart';

class TimelineModel extends TimelineEntity {
  TimelineModel({
    required super.address,
    required super.description,
    required super.dateTime,
  });

  factory TimelineModel.fromJson(Map<String, dynamic> json) {
    return TimelineModel(
      address: json['alamat'],
      description: json['keterangan'],
      dateTime: DateTime.tryParse(json['tanggal']) ?? DateTime.now(),
    );
  }

  TimelineEntity toEntity() {
    return TimelineEntity(
      address: address,
      description: description,
      dateTime: dateTime,
    );
  }
}
