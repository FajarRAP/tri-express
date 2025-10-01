import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.title,
    required super.message,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      message: json['message'],
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      title: title,
      message: message,
    );
  }
}
