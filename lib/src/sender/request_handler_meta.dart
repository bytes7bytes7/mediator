part of 'sender.dart';

class RequestHandlerMeta {
  RequestHandlerMeta._({
    required this.handlerCreator,
    required this.requestType,
  });

  final RequestHandlerCreator handlerCreator;

  final Type requestType;

  static RequestHandlerMeta create<RS, RQ extends Request<RS>>(
    RequestHandlerCreator<RS, RQ> handlerCreator,
  ) {
    return RequestHandlerMeta._(
      handlerCreator: handlerCreator,
      requestType: RQ,
    );
  }
}
