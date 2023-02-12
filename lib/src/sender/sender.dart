import 'dart:async';

part 'pipeline_behavior.dart';

part 'request.dart';

part 'request_handler.dart';

part 'stream_request.dart';

part 'stream_request_handler.dart';

part 'stream_pipeline_behavior.dart';

typedef RequestHandlerCreator<RS, RQ extends Request<RS>>
    = RequestHandler<RS, RQ> Function();
typedef StreamRequestHandlerCreator<RS, RQ extends StreamRequest<RS>>
    = StreamRequestHandler<RS, RQ> Function();
typedef PipelineBehaviorCreator<RS, RQ extends Request<RS>>
    = PipelineBehavior<RS, RQ> Function();
typedef StreamPipelineBehaviorCreator<RS, RQ extends StreamRequest<RS>>
    = StreamPipelineBehavior<RS, RQ> Function();

abstract class Sender {
  const Sender();

  void registerRequestHandler<RS, RQ extends Request<RS>>(
    RequestHandlerCreator<RS, RQ> creator,
  );

  void registerStreamRequestHandler<RS, RQ extends StreamRequest<RS>>(
    StreamRequestHandlerCreator<RS, RQ> creator,
  );

  void registerPipelineBehavior<RS, RQ extends Request<RS>>(
    PipelineBehaviorCreator<RS, RQ> creator,
  );

  void registerStreamPipelineBehavior<RS, RQ extends StreamRequest<RS>>(
    StreamPipelineBehaviorCreator<RS, RQ> creator,
  );

  @Deprecated('Use `sendTo` method of `Request` instead')
  Future<RS> send<RS, RQ extends Request<RS>>({
    required RQ request,
    required Type requestType,
    required Type responseType,
  });

  @Deprecated('Use `createStream` method of `StreamRequest` instead')
  Stream<RS> createStream<RS, RQ extends StreamRequest<RS>>({
    required RQ request,
    required Type requestType,
    required Type responseType,
  });
}
