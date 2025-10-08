class UHFResultEntity {
  UHFResultEntity({
    required this.epcId,
    required this.tidId,
    required this.frequency,
    required this.rssi,
    required this.count,
  });

  final String epcId;
  final String tidId;
  int frequency;
  int rssi;
  int count;

  void updateInfo({required UHFResultEntity tagInfo}) {
    frequency = tagInfo.frequency;
    rssi = tagInfo.rssi;
    count++;
  }
}
