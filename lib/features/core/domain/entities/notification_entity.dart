import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.title,
    required this.message,
    required this.createdAt,
    this.readAt,
  });

  final String title;
  final String message;
  final DateTime createdAt;
  final DateTime? readAt;

  @override
  List<Object?> get props => [title, message, createdAt, readAt];
}
