import 'dart:async';

import 'package:meta/meta.dart';

import '../sender.dart';
import 'request_exception_handler_state.dart';

abstract class RequestExceptionHandler<RS, RQ extends Request<RS>,
    E extends Exception> {
  const RequestExceptionHandler();

  /// Call the super method first.
  @mustCallSuper
  @mustBeOverridden
  @useResult
  FutureOr<RequestExceptionHandlerState<RS>> handle(
    RQ request,
    Object exception,
    RequestExceptionHandlerState<RS> state,
  ) async {
    if (exception is! E) {
      throw Exception('$exception is not $E');
    }

    return state;
  }
}
