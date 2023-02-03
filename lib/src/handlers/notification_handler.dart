import 'dart:async';

import '../models/notification.dart';

abstract class NotificationHandler<N extends Notification> {
  FutureOr<void> handle(N notification);
}
