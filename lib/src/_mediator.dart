part of 'mediator.dart';

class _Mediator implements Mediator {
  final _requestHandlerCreators = HashMap<Type, RequestHandlerCreator>();
  final _streamRequestHandlerCreators =
      HashMap<Type, StreamRequestHandlerCreator>();
  final _notificationHandlerCreators =
      HashMap<Type, List<NotificationHandlerCreator>>();
  final _pipelineBehaviorCreators =
      HashMap<Type, List<PipelineBehaviorCreator>>();
  final _streamPipelineBehaviorCreators =
      HashMap<Type, List<StreamPipelineBehaviorCreator>>();

  @override
  void registerRequestHandler<RS, RQ extends Request<RS>>(
    RequestHandlerCreator<RS, RQ> creator,
  ) {
    _requestHandlerCreators[RQ] = creator;
  }

  @override
  void registerStreamRequestHandler<RS, RQ extends StreamRequest<RS>>(
    StreamRequestHandlerCreator<RS, RQ> creator,
  ) {
    _streamRequestHandlerCreators[RQ] = creator;
  }

  @override
  void registerNotificationHandler<N extends Notification>(
    NotificationHandlerCreator<N> creator,
  ) {
    final creators = _notificationHandlerCreators[N];

    if (creators == null) {
      _notificationHandlerCreators[N] = <NotificationHandlerCreator<N>>[
        creator
      ];
    } else {
      _notificationHandlerCreators[N] = creators..add(creator);
    }
  }

  @override
  void registerPipelineBehavior<RS, RQ extends Request<RS>>(
    PipelineBehaviorCreator<RS, RQ> creator,
  ) {
    final creators = _pipelineBehaviorCreators[RQ];

    if (creators == null) {
      _pipelineBehaviorCreators[RQ] = <PipelineBehaviorCreator>[
        creator,
      ];
    } else {
      _pipelineBehaviorCreators[RQ] = creators..add(creator);
    }
  }

  @override
  void registerStreamPipelineBehavior<RS, RQ extends StreamRequest<RS>>(
    StreamPipelineBehaviorCreator<RS, RQ> creator,
  ) {
    final creators = _streamPipelineBehaviorCreators[RQ];

    if (creators == null) {
      _streamPipelineBehaviorCreators[RQ] = <StreamPipelineBehaviorCreator>[
        creator,
      ];
    } else {
      _streamPipelineBehaviorCreators[RQ] = creators..add(creator);
    }
  }

  @override
  Future<RS> send<RS, RQ extends Request<RS>>({
    required RQ request,
    required Type requestType,
    required Type responseType,
  }) async {
    final handlerCreator = _requestHandlerCreators[requestType];

    if (handlerCreator == null) {
      throw RequestHandlerNotRegistered(
        requestType: requestType,
        responseType: responseType,
      );
    }

    final handler = handlerCreator.call();

    final behaviors = _pipelineBehaviorCreators[requestType]?.reversed ?? [];

    return behaviors.fold<RequestHandlerDelegate<RS>>(
      () => handler.handle(request) as FutureOr<RS>,
      (prev, curr) => () => curr().handle(request, prev) as FutureOr<RS>,
    )();
  }

  @override
  Stream<RS> createStream<RS, RQ extends StreamRequest<RS>>({
    required RQ request,
    required Type requestType,
    required Type responseType,
  }) {
    final handlerCreator = _streamRequestHandlerCreators[requestType];

    if (handlerCreator == null) {
      throw StreamRequestHandlerNotRegistered(
        requestType: requestType,
        responseType: responseType,
      );
    }

    final handler = handlerCreator.call();

    final behaviors =
        _streamPipelineBehaviorCreators[requestType]?.reversed ?? [];

    return behaviors.fold<StreamHandlerDelegate<RS>>(
      () => handler.handle(request) as Stream<RS>,
      (prev, curr) => () =>
          curr().handle(request, () => _nextWrapper(prev())) as Stream<RS>,
    )();
  }

  @override
  Future<void> publish<N extends Notification>({
    required N notification,
    required Type notificationType,
  }) {
    final handlerCreators = _notificationHandlerCreators[notificationType];

    if (handlerCreators == null || handlerCreators.isEmpty) {
      throw NotificationHandlerNotRegistered(notificationType);
    }

    for (final creator in handlerCreators) {
      creator.call().handle(notification);
    }

    return Future.value(null);
  }

  Stream<T> _nextWrapper<T>(Stream<T> items) async* {
    await for (final item in items) {
      yield item;
    }
  }
}
