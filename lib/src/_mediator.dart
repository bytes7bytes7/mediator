part of 'mediator.dart';

class _Mediator implements Mediator {
  final _requestHandlers = HashMap<Type, RequestHandler>();
  final _notificationHandlers = HashMap<Type, NotificationHandler>();
  final _streamRequestHandlers = HashMap<Type, StreamRequestHandler>();

  @override
  Future<RS> send<RS>(Request<RS> request) async {
    final handler = _requestHandlers[Request<RS>];

    if (handler is! RequestHandler<Request<RS>, RS>) {
      throw Exception('Request handler for ${Request<RS>} is not registered');
    }

    return handler.handle(request);
  }

  @override
  Stream<RS> createStream<RS>(Request<RS> request) {
    final handler = _streamRequestHandlers[Request<RS>];

    if (handler is! StreamRequestHandler<Request<RS>, RS>) {
      throw Exception(
        'Stream request handler for ${Request<RS>} is not registered',
      );
    }

    return handler.handle(request);
  }

  @override
  Future<void> publish<N extends Notification>(N notification) async {
    final handler = _notificationHandlers[N];

    if (handler is! NotificationHandler<N>) {
      throw Exception('Notification handler for $N is not registered');
    }

    return handler.handle(notification);
  }
}
