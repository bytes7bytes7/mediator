import 'dart:async';

import '../sender.dart';
import 'request_exception_action.dart';

class RequestExceptionActionProcessorBehavior<RS, RQ extends Request<RS>>
    implements PipelineBehavior<RS, RQ> {
  const RequestExceptionActionProcessorBehavior(this._actions);

  final List<RequestExceptionAction<RS, RQ, Exception>> _actions;

  @override
  FutureOr<RS> handle(RQ request, RequestHandlerDelegate<RS> next) async {
    try {
      return await next();
    } catch (e) {
      for (final action in _actions) {
        try {
          await action.execute(request, e);
        } catch (_) {}
      }

      rethrow;
    }
  }
}
