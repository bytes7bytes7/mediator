import 'dart:collection';

import 'exceptions/exceptions.dart';
import 'models/models.dart';
import 'pipeline/pipeline.dart';
import 'publisher.dart';
import 'sender.dart';

part '_mediator.dart';

abstract class Mediator implements Sender, Publisher {
  factory Mediator() = _Mediator;
}
