import 'dart:collection';

import 'models/models.dart';
import 'pipeline/pipeline.dart';
import 'publisher.dart';
import 'sender.dart';

part '_mediator.dart';

abstract class Mediator implements Sender, Publisher {
  factory Mediator() = _Mediator;
}
