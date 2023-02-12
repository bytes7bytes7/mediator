part of 'publisher.dart';

abstract class Notification {
  Notification(this._notificationType);

  final Type _notificationType;

  Future<void> publishTo(Publisher publisher) {
    // ignore: deprecated_member_use_from_same_package
    return publisher.publish(
      notification: this,
      notificationType: _notificationType,
    );
  }
}
