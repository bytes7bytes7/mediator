import 'dart:async';

import '../sender.dart';
import 'request_exception_handler_state.dart';

abstract class RequestExceptionHandler<RS, RQ extends Request<RS>,
    E extends Exception> {
  const RequestExceptionHandler();

  FutureOr<RequestExceptionHandlerState<RS>> handle(
    RQ request,
    E exception,
    RequestExceptionHandlerState<RS> state,
  );
}
