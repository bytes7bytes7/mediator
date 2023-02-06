part of 'mediator.dart';

class _Mediator implements Mediator {
  final _requestHandlerCreators = HashMap<Type, RequestHandlerCreator>();
  final _streamRequestHandlerCreators =
      HashMap<Type, StreamRequestHandlerCreator>();
  final _notificationHandlerCreators =
      HashMap<Type, NotificationHandlerCreator>();
  final _pipelineBehaviorCreators =
      HashMap<Type, List<PipelineBehaviorCreator>>();
  final _streamPipelineBehaviorCreators =
      HashMap<Type, List<StreamPipelineBehaviorCreator>>();

  @override
  void registerRequestHandler<RQ extends Request, RS>(
    RequestHandlerCreator<RQ, RS> creator,
  ) {
    _requestHandlerCreators[RQ] = creator;
  }

  @override
  void registerStreamRequestHandler<RQ extends Request, RS>(
    StreamRequestHandlerCreator<RQ, RS> creator,
  ) {
    _streamRequestHandlerCreators[RQ] = creator;
  }

  @override
  void registerNotificationHandler<N extends Notification>(
    NotificationHandlerCreator<N> creator,
  ) {
    _notificationHandlerCreators[N] = creator;
  }

  @override
  void registerPipelineBehavior<RQ extends Request, RS>(
    PipelineBehaviorCreator<RQ, RS> creator,
  ) {
    final creators = _pipelineBehaviorCreators[RQ];

    if (creators == null) {
      _pipelineBehaviorCreators[RQ] = [creator];
    } else {
      _pipelineBehaviorCreators[RQ] = creators..add(creator);
    }
  }

  @override
  void registerStreamPipelineBehavior<RQ extends Request, RS>(
    StreamPipelineBehaviorCreator<RQ, RS> creator,
  ) {
    final creators = _streamPipelineBehaviorCreators[RQ];

    if (creators == null) {
      _streamPipelineBehaviorCreators[RQ] = [creator];
    } else {
      _streamPipelineBehaviorCreators[RQ] = creators..add(creator);
    }
  }

  @override
  Future<RS> send<RS>(Request<RS> request) async {
    final handlerCreator = _requestHandlerCreators[Request<RS>];

    if (handlerCreator is! RequestHandlerCreator<Request<RS>, RS>) {
      throw Exception('Request handler for ${Request<RS>} is not registered');
    }

    final handler = handlerCreator.call();

    final behaviors = _pipelineBehaviorCreators[Request<RS>]
            as List<PipelineBehaviorCreator<Request<RS>, RS>>? ??
        [];

    return behaviors.fold<RequestHandlerDelegate<RS>>(
      () => handler.handle(request),
      (prev, curr) => () => curr().handle(request, prev),
    )();
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

    final behaviors = _streamPipelineBehaviorCreators[Request<RS>]
            as List<StreamPipelineBehaviorCreator<Request<RS>, RS>>? ??
        [];

    return behaviors.fold<StreamHandlerDelegate<RS>>(
      () => handler.handle(request),
      (prev, curr) => () => curr().handle(request, () => _nextWrapper(prev())),
    )();
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

  Stream<T> _nextWrapper<T>(Stream<T> items) async* {
    await for (final item in items) {
      yield item;
    }
  }
}
