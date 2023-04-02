import '../sender.dart';
import 'request_exception_handler.dart';

extension RequestExceptionHandlerWrapperX<RQ extends Request<RS>,
    E extends Exception, RS> on RequestExceptionHandler<RQ, E, RS> {
  RequestExceptionHandlerWrapper<RQ, E, RS> get wrapper =>
      RequestExceptionHandlerWrapper(this);
}

class RequestExceptionHandlerWrapper<RQ extends Request<RS>,
    E extends Exception, RS> {
  const RequestExceptionHandlerWrapper(this._handler);

  final RequestExceptionHandler<RQ, E, RS> _handler;

  RequestExceptionHandler<RQ, E, RS>? wrap(Object exception) {
    if (exception is E) {
      return _handler;
    }

    return null;
  }
}
