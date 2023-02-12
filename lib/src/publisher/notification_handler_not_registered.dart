part of 'publisher.dart';

class NotificationHandlerNotRegistered implements Exception {
  const NotificationHandlerNotRegistered(this.notificationType);

  final Type notificationType;

  @override
  String toString() =>
      '$NotificationHandler<$notificationType> is not registered';
}
