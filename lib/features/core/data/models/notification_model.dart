import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.title,
    required super.message,
    required super.createdAt,
    super.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['data']['title'],
      message: json['data']['message'],
      createdAt: DateTime.parse(json['created_at']),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      title: title,
      message: message,
      createdAt: createdAt,
      readAt: readAt,
    );
  }
}
