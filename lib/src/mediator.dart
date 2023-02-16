import 'dart:async';
import 'dart:collection';

import 'publisher/notification_handler_not_registered.dart';
import 'publisher/publisher.dart';
import 'sender/exceptions/exceptions.dart';
import 'sender/sender.dart';

part '_mediator.dart';

abstract class Mediator implements Sender, Publisher {
  factory Mediator() = _Mediator;
}
