import 'dart:async';

import '../models/request.dart';
import 'pipeline.dart';

class RequestExceptionProcessorBehavior<RQ extends Request<RS>, RS>
    implements PipelineBehavior<RQ, RS> {
  const RequestExceptionProcessorBehavior(this._handlers);

  final List<RequestExceptionHandler<RQ, RS, Exception>> _handlers;

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
