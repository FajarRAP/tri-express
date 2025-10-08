import 'timeline_entity.dart';

class TimelineSummaryEntity {
  const TimelineSummaryEntity({
    required this.status,
    required this.statusLabel,
    required this.timelines,
  });

  final int status;
  final String statusLabel;
  final List<TimelineEntity> timelines;
}
