import 'models/models.dart';

abstract class Publisher {
  const Publisher();

  Future<void> publish<N extends Notification>(N notification);
}
