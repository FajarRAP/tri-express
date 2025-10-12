class UHFResultEntity {
  UHFResultEntity({
    required this.epcId,
    required this.tidId,
    required this.frequency,
    required this.rssi,
    required this.count,
  });

  UHFResultEntity copyWith({
    String? epcId,
    String? tidId,
    int? frequency,
    int? rssi,
    int? count,
  }) {
    return UHFResultEntity(
      epcId: epcId ?? this.epcId,
      tidId: tidId ?? this.tidId,
      frequency: frequency ?? this.frequency,
      rssi: rssi ?? this.rssi,
      count: count ?? this.count,
    );
  }

  final String epcId;
  final String tidId;
  final int frequency;
  final int rssi;
  final int count;

  UHFResultEntity updateInfo({required UHFResultEntity tagInfo}) {
    return copyWith(
      frequency: tagInfo.frequency,
      rssi: tagInfo.rssi,
      count: count + 1,
    );
  }
}
