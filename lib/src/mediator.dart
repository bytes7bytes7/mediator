import 'publisher.dart';
import 'sender.dart';

abstract class Mediator implements Sender, Publisher {
  const Mediator();
}
