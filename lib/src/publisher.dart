import 'handlers/notification_handler.dart';
import 'models/models.dart';

typedef NotificationHandlerCreator<N extends Notification>
    = NotificationHandler<N> Function();

abstract class Publisher {
  const Publisher();

  void registerNotificationHandler<N extends Notification>(
    NotificationHandlerCreator<N> creator,
  );

  Future<void> publish<N extends Notification>(N notification);
}
