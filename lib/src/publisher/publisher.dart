import 'dart:async';

part 'notification.dart';

part 'notification_handler.dart';

typedef NotificationHandlerCreator<N extends Notification>
    = NotificationHandler<N> Function();

abstract class Publisher {
  const Publisher();

  void registerNotificationHandler<N extends Notification>(
    NotificationHandlerCreator<N> creator,
  );

  @Deprecated('Use `publishTo` method of `Notification` instead')
  Future<void> publish<N extends Notification>({
    required N notification,
    required Type notificationType,
  });
}
