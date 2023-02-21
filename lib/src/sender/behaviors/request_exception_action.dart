import 'dart:async';

import '../sender.dart';

abstract class RequestExceptionAction<RS, RQ extends Request<RS>,
    E extends Exception> {
  const RequestExceptionAction();

  FutureOr<void> execute(RQ request, E exception);
}
