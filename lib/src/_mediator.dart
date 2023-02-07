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
  void registerRequestHandler<RS>(
    RequestHandlerCreator<Request<RS>, RS> creator,
  ) {
    _requestHandlerCreators[Request<RS>] = creator;
  }

  @override
  void registerStreamRequestHandler<RS>(
    StreamRequestHandlerCreator<Request<RS>, RS> creator,
  ) {
    _streamRequestHandlerCreators[Request<RS>] = creator;
  }

  @override
  void registerNotificationHandler<N extends Notification>(
    NotificationHandlerCreator<N> creator,
  ) {
    _notificationHandlerCreators[N] = creator;
  }

  @override
  void registerPipelineBehavior<RS>(
    PipelineBehaviorCreator<Request<RS>, RS> creator,
  ) {
    final creators = _pipelineBehaviorCreators[Request<RS>];

    if (creators == null) {
      _pipelineBehaviorCreators[Request<RS>] =
          <PipelineBehaviorCreator<Request<RS>, RS>>[creator];
    } else {
      _pipelineBehaviorCreators[Request<RS>] = creators..add(creator);
    }
  }

  @override
  void registerStreamPipelineBehavior<RS>(
    StreamPipelineBehaviorCreator<Request<RS>, RS> creator,
  ) {
    final creators = _streamPipelineBehaviorCreators[Request<RS>];

    if (creators == null) {
      _streamPipelineBehaviorCreators[Request<RS>] =
          <StreamPipelineBehaviorCreator<Request<RS>, RS>>[creator];
    } else {
      _streamPipelineBehaviorCreators[Request<RS>] = creators..add(creator);
    }
  }

  @override
  Future<RS> send<RS>(Request<RS> request) async {
    final handlerCreator = _requestHandlerCreators[Request<RS>];

    if (handlerCreator is! RequestHandlerCreator<Request<RS>, RS>) {
      throw RequestHandlerNotRegistered<
          RequestHandlerCreator<Request<RS>, RS>>();
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
      throw StreamRequestHandlerNotRegistered<
          StreamRequestHandlerCreator<Request<RS>, RS>>();
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
      throw NotificationHandlerNotRegistered<NotificationHandlerCreator<N>>();
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
