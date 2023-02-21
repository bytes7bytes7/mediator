import '../sender.dart';
import 'request_exception_action.dart';

extension RequestExceptionActionWrapperX<RS, RQ extends Request<RS>,
    E extends Exception> on RequestExceptionAction<RS, RQ, E> {
  RequestExceptionActionWrapper<RS, RQ, E> get wrapper =>
      RequestExceptionActionWrapper(this);
}

class RequestExceptionActionWrapper<RS, RQ extends Request<RS>,
    E extends Exception> {
  const RequestExceptionActionWrapper(this._action);

  final RequestExceptionAction<RS, RQ, E> _action;

  RequestExceptionAction<RS, RQ, E>? wrap(Object exception) {
    if (exception is E) {
      return _action;
    }

    return null;
  }
}
