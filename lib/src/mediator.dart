import 'dart:collection';

import 'handlers/handlers.dart';
import 'models/models.dart';
import 'publisher.dart';
import 'sender.dart';

part '_mediator.dart';

typedef RequestHandlerCreator<RQ extends Request, RS> = RequestHandler<RQ, RS>
    Function();
typedef NotificationHandlerCreator<N extends Notification>
    = NotificationHandler<N> Function();
typedef StreamRequestHandlerCreator<RQ extends Request, RS>
    = StreamRequestHandler<RQ, RS> Function();

abstract class Mediator implements Sender, Publisher {
  factory Mediator() = _Mediator;

  void registerRequestHandler<RQ extends Request, RS>(
    RequestHandlerCreator<RQ, RS> creator,
  );

  void registerNotificationHandler<N extends Notification>(
    NotificationHandlerCreator<N> creator,
  );

  void registerStreamRequestHandler<RQ extends Request, RS>(
    StreamRequestHandlerCreator<RQ, RS> creator,
  );
}
