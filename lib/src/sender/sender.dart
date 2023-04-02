import 'dart:async';

part 'pipeline_behavior.dart';

part 'request.dart';

part 'request_handler.dart';

part 'stream_request.dart';

part 'stream_request_handler.dart';

part 'stream_pipeline_behavior.dart';

typedef RequestHandlerCreator<RQ extends Request<RS>, RS>
    = RequestHandler<RQ, RS> Function();
typedef StreamRequestHandlerCreator<RQ extends StreamRequest<RS>, RS>
    = StreamRequestHandler<RQ, RS> Function();
typedef PipelineBehaviorCreator<RQ extends Request<RS>, RS>
    = PipelineBehavior<RQ, RS> Function();
typedef StreamPipelineBehaviorCreator<RQ extends StreamRequest<RS>, RS>
    = StreamPipelineBehavior<RQ, RS> Function();

abstract class Sender {
  const Sender();

  void registerRequestHandler<RQ extends Request<RS>, RS>(
    RequestHandlerCreator<RQ, RS> creator,
  );

  void registerStreamRequestHandler<RQ extends StreamRequest<RS>, RS>(
    StreamRequestHandlerCreator<RQ, RS> creator,
  );

  void registerPipelineBehavior<RQ extends Request<RS>, RS>(
    PipelineBehaviorCreator<RQ, RS> creator,
  );

  void registerStreamPipelineBehavior<RQ extends StreamRequest<RS>, RS>(
    StreamPipelineBehaviorCreator<RQ, RS> creator,
  );

  @Deprecated('Use `sendTo` method of `Request` instead')
  Future<RS> send<RQ extends Request<RS>, RS>({
    required RQ request,
    required Type requestType,
    required Type responseType,
  });

  @Deprecated('Use `createStream` method of `StreamRequest` instead')
  Stream<RS> createStream<RQ extends StreamRequest<RS>, RS>({
    required RQ request,
    required Type requestType,
    required Type responseType,
  });
}
