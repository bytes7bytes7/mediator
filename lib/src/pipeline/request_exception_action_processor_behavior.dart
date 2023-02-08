import 'dart:async';

import '../models/request.dart';
import 'pipeline_behavior.dart';
import 'request_exception_action.dart';

class RequestExceptionActionProcessorBehavior<RQ extends Request<RS>, RS>
    implements PipelineBehavior<RQ, RS> {
  const RequestExceptionActionProcessorBehavior(this._actions);

  final List<RequestExceptionAction<RQ, Exception>> _actions;

  @override
  FutureOr<RS> handle(RQ request, RequestHandlerDelegate<RS> next) async {
    try {
      return await next();
    } catch (e) {
      for (final action in _actions) {
        try {
          action.execute(request, e);
        } catch (_) {}
      }

      rethrow;
    }
  }
}
