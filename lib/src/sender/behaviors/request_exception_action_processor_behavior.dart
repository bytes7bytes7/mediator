import 'dart:async';

import '../sender.dart';
import 'request_exception_action_wrapper.dart';

class RequestExceptionActionProcessorBehavior<RS, RQ extends Request<RS>>
    implements PipelineBehavior<RS, RQ> {
  const RequestExceptionActionProcessorBehavior(this._actionWrappers);

  final List<RequestExceptionActionWrapper<RS, RQ, Exception>> _actionWrappers;

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
