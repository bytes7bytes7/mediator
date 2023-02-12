import 'dart:async';

import '../sender.dart';
import 'request_exception_handler.dart';
import 'request_exception_handler_state.dart';

class RequestExceptionProcessorBehavior<RS, RQ extends Request<RS>>
    implements PipelineBehavior<RS, RQ> {
  const RequestExceptionProcessorBehavior(this._handlers);

  final List<RequestExceptionHandler<RS, RQ, Exception>> _handlers;

  @override
  FutureOr<RS> handle(RQ request, RequestHandlerDelegate<RS> next) async {
    try {
      return await next();
    } catch (e) {
      var state = RequestExceptionHandlerState<RS>();

      for (final handler in _handlers) {
        try {
          state = await handler.handle(request, e, state);
        } catch (_) {}

        if (state.isHandled) {
          break;
        }
      }

      if (!state.isHandled) {
        rethrow;
      }

      final response = state.response;
      if (response == null) {
        rethrow;
      }

      return response;
    }
  }
}
