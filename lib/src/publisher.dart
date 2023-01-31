import 'models/models.dart';

abstract class Publisher {
  const Publisher();

  Future<void> publish(Notification notification);
}
