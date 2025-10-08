import '../../domain/entities/timeline_summary_entity.dart';
import 'timeline_model.dart';

class TimelineSummaryModel extends TimelineSummaryEntity {
  const TimelineSummaryModel({
    required super.status,
    required super.statusLabel,
    required super.timelines,
  });

  factory TimelineSummaryModel.fromJson(Map<String, dynamic> json) {
    final timelines = List.from(json['timeline']);

    return TimelineSummaryModel(
      status: json['status'],
      statusLabel: json['status_label'],
      timelines:
          timelines.map((e) => TimelineModel.fromJson(e).toEntity()).toList(),
    );
  }

  TimelineSummaryEntity toEntity() {
    return TimelineSummaryEntity(
      status: status,
      statusLabel: statusLabel,
      timelines: timelines,
    );
  }
}
