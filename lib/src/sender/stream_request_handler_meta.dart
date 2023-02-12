part of 'sender.dart';

class StreamRequestHandlerMeta {
  StreamRequestHandlerMeta._({
    required this.handlerCreator,
    required this.requestType,
  });

  final StreamRequestHandlerCreator handlerCreator;

  final Type requestType;

  static StreamRequestHandlerMeta create<RS, RQ extends StreamRequest<RS>>(
    StreamRequestHandlerCreator<RS, RQ> handlerCreator,
  ) {
    return StreamRequestHandlerMeta._(
      handlerCreator: handlerCreator,
      requestType: RQ,
    );
  }
}
