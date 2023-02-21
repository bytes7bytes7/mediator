import '../sender.dart';
import 'request_exception_handler.dart';

extension X<RS, RQ extends Request<RS>, E extends Exception>
    on RequestExceptionHandler<RS, RQ, E> {
  RequestExceptionHandlerWrapper<RS, RQ, E> get wrapper =>
      RequestExceptionHandlerWrapper(this);
}

class RequestExceptionHandlerWrapper<RS, RQ extends Request<RS>,
    E extends Exception> {
  const RequestExceptionHandlerWrapper(this._handler);

  final RequestExceptionHandler<RS, RQ, E> _handler;

  RequestExceptionHandler<RS, RQ, E>? wrap(Object exception) {
    if (exception is E) {
      return _handler;
    }

    return null;
  }
}
