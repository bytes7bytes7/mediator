import '../sender.dart';
import 'request_exception_action.dart';

extension RequestExceptionActionWrapperX<RQ extends Request<RS>,
    E extends Exception, RS> on RequestExceptionAction<RQ, E, RS> {
  RequestExceptionActionWrapper<RQ, E, RS> get wrapper =>
      RequestExceptionActionWrapper(this);
}

class RequestExceptionActionWrapper<RQ extends Request<RS>, E extends Exception,
    RS> {
  const RequestExceptionActionWrapper(this._action);

  final RequestExceptionAction<RQ, E, RS> _action;

  RequestExceptionAction<RQ, E, RS>? wrap(Object exception) {
    if (exception is E) {
      return _action;
    }

    return null;
  }
}
