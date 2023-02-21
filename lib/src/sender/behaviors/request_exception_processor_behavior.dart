import 'dart:async';

import '../sender.dart';
import 'request_exception_handler_state.dart';
import 'request_exception_handler_wrapper.dart';

class RequestExceptionProcessorBehavior<RS, RQ extends Request<RS>>
    implements PipelineBehavior<RS, RQ> {
  const RequestExceptionProcessorBehavior(this._handlerWrappers);

  final List<RequestExceptionHandlerWrapper<RS, RQ, Exception>>
      _handlerWrappers;

  @override
  FutureOr<RS> handle(RQ request, RequestHandlerDelegate<RS> next) async {
    try {
      return await next();
    } catch (e) {
      var state = RequestExceptionHandlerState<RS>();

      for (final wrapper in _handlerWrappers) {
        final handler = wrapper.wrap(e);

        if (handler != null) {
          try {
            state = await handler.handle(request, e as Exception, state);
          } catch (_) {}
        }

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
