class UHFResultModel {
  int count;
  final String epcId;
  int frequency;
  int rssi;
  final String tidId;

  UHFResultModel({
    this.count = 1,
    required this.epcId,
    required this.frequency,
    required this.rssi,
    required this.tidId,
  });

  factory UHFResultModel.fromJson(Map<String, dynamic> json) => UHFResultModel(
    epcId: json['epc_id'] ?? '-',
    frequency: json['frequency'] ?? 0,
    rssi: json['rssi'] ?? 0,
    tidId: json['tid_id'] ?? '-',
  );

  void updateInfo({required UHFResultModel tagInfo}) {
    frequency = tagInfo.frequency;
    rssi = tagInfo.rssi;
    count++;
  }
}
