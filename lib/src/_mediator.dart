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
  void registerRequestHandler<RQ extends Request<RS>, RS>(
    RequestHandlerCreator<RQ, RS> creator,
  ) {
    _requestHandlerCreators[RQ] = creator;
  }

  @override
  void registerStreamRequestHandler<RQ extends StreamRequest<RS>, RS>(
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
  void registerPipelineBehavior<RQ extends Request<RS>, RS>(
    PipelineBehaviorCreator<RQ, RS> creator,
  ) {
    final creators = _pipelineBehaviorCreators[RQ];

    if (creators == null) {
      _pipelineBehaviorCreators[RQ] = <PipelineBehaviorCreator<RQ, RS>>[
        creator
      ];
    } else {
      _pipelineBehaviorCreators[RQ] = creators..add(creator);
    }
  }

  @override
  void registerStreamPipelineBehavior<RQ extends StreamRequest<RS>, RS>(
    StreamPipelineBehaviorCreator<RQ, RS> creator,
  ) {
    final creators = _streamPipelineBehaviorCreators[RQ];

    if (creators == null) {
      _streamPipelineBehaviorCreators[RQ] =
          <StreamPipelineBehaviorCreator<RQ, RS>>[creator];
    } else {
      _streamPipelineBehaviorCreators[RQ] = creators..add(creator);
    }
  }

  @override
  Future<RS> send<RQ extends Request<RS>, RS>(RQ request) async {
    final handlerCreator = _requestHandlerCreators[RQ];

    if (handlerCreator is! RequestHandlerCreator<RQ, RS>) {
      throw RequestHandlerNotRegistered<RequestHandlerCreator<RQ, RS>, RQ,
          RS>();
    }

    final handler = handlerCreator.call();

    final behaviors = _pipelineBehaviorCreators[RQ]
            as List<PipelineBehaviorCreator<RQ, RS>>? ??
        [];

    return behaviors.fold<RequestHandlerDelegate<RS>>(
      () => handler.handle(request),
      (prev, curr) => () => curr().handle(request, prev),
    )();
  }

  @override
  Stream<RS> createStream<RQ extends StreamRequest<RS>, RS>(RQ request) {
    final handlerCreator = _streamRequestHandlerCreators[RQ];

    if (handlerCreator is! StreamRequestHandlerCreator<RQ, RS>) {
      throw StreamRequestHandlerNotRegistered<
          StreamRequestHandlerCreator<RQ, RS>, RQ, RS>();
    }

    final handler = handlerCreator.call();

    final behaviors = _streamPipelineBehaviorCreators[RQ]
            as List<StreamPipelineBehaviorCreator<RQ, RS>>? ??
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
