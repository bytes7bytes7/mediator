import 'dart:collection';

import 'handlers/handlers.dart';
import 'models/models.dart';
import 'publisher.dart';
import 'sender.dart';

part '_mediator.dart';

abstract class Mediator implements Sender, Publisher {
  factory Mediator() = _Mediator;
}
