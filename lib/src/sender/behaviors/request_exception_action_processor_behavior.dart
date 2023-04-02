import 'dart:async';

import '../sender.dart';
import 'request_exception_action_wrapper.dart';

class RequestExceptionActionProcessorBehavior<RQ extends Request<RS>, RS>
    implements PipelineBehavior<RQ, RS> {
  const RequestExceptionActionProcessorBehavior(this._actionWrappers);

  final List<RequestExceptionActionWrapper<RQ, Exception, RS>> _actionWrappers;

  @override
  FutureOr<RS> handle(RQ request, RequestHandlerDelegate<RS> next) async {
    try {
      return await next();
    } catch (e) {
      for (final wrapper in _actionWrappers) {
        final action = wrapper.wrap(e);

        if (action != null) {
          try {
            await action.execute(request, e as Exception);
          } catch (_) {}
        }
      }

      rethrow;
    }
  }
}
