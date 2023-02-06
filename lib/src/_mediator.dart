part of 'mediator.dart';

class _Mediator implements Mediator {
  final _requestHandlerCreators = HashMap<Type, RequestHandlerCreator>();
  final _notificationHandlerCreators =
      HashMap<Type, NotificationHandlerCreator>();
  final _streamRequestHandlerCreators =
      HashMap<Type, StreamRequestHandlerCreator>();

  @override
  void registerRequestHandler<RQ extends Request, RS>(
    RequestHandlerCreator<RQ, RS> creator,
  ) {
    _requestHandlerCreators[RQ] = creator;
  }

  @override
  void registerNotificationHandler<N extends Notification>(
    NotificationHandlerCreator<N> creator,
  ) {
    _notificationHandlerCreators[N] = creator;
  }

  @override
  void registerStreamRequestHandler<RQ extends Request, RS>(
    StreamRequestHandlerCreator<RQ, RS> creator,
  ) {
    _streamRequestHandlerCreators[RQ] = creator;
  }

  @override
  Future<RS> send<RS>(Request<RS> request) async {
    final handlerCreator = _requestHandlerCreators[Request<RS>];

    if (handlerCreator is! RequestHandlerCreator<Request<RS>, RS>) {
      throw Exception('Request handler for ${Request<RS>} is not registered');
    }

    final handler = handlerCreator.call();

    return handler.handle(request);
  }

  @override
  Stream<RS> createStream<RS>(Request<RS> request) {
    final handlerCreator = _streamRequestHandlerCreators[Request<RS>];

    if (handlerCreator is! StreamRequestHandlerCreator<Request<RS>, RS>) {
      throw Exception(
        'Stream request handler for ${Request<RS>} is not registered',
      );
    }

    final handler = handlerCreator.call();

    return handler.handle(request);
  }

  @override
  Future<void> publish<N extends Notification>(N notification) async {
    final handlerCreator = _notificationHandlerCreators[N];

    if (handlerCreator is! NotificationHandlerCreator<N>) {
      throw Exception('Notification handler for $N is not registered');
    }

    final handler = handlerCreator.call();

    return handler.handle(notification);
  }
}
