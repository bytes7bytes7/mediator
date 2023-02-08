import 'dart:async';

import 'package:meta/meta.dart';

import '../models/request.dart';
import 'request_exception_handler_state.dart';

abstract class RequestExceptionHandler<RQ extends Request<RS>, RS,
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
