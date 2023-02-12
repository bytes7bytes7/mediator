part of 'publisher.dart';

abstract class NotificationHandler<N extends Notification> {
  FutureOr<void> handle(N notification);
}
