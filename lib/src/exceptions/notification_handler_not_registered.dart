import '../publisher.dart';

class NotificationHandlerNotRegistered<T extends NotificationHandlerCreator>
    implements Exception {
  @override
  String toString() => '$T is not registered';
}
