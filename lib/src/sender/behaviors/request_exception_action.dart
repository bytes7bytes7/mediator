import 'dart:async';

import '../sender.dart';

abstract class RequestExceptionAction<RQ extends Request<RS>,
    E extends Exception, RS> {
  const RequestExceptionAction();

  FutureOr<void> execute(RQ request, E exception);
}
