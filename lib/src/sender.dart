import 'handlers/request_handler.dart';
import 'handlers/stream_request_handler.dart';
import 'models/request.dart';
import 'pipeline/pipeline_behavior.dart';
import 'pipeline/stream_pipeline_behavior.dart';

typedef RequestHandlerCreator<RQ extends Request, RS> = RequestHandler<RQ, RS>
    Function();
typedef StreamRequestHandlerCreator<RQ extends Request, RS>
    = StreamRequestHandler<RQ, RS> Function();
typedef PipelineBehaviorCreator<RQ extends Request, RS>
    = PipelineBehavior<RQ, RS> Function();
typedef StreamPipelineBehaviorCreator<RQ extends Request, RS>
    = StreamPipelineBehavior<RQ, RS> Function();

abstract class Sender {
  const Sender();

  void registerRequestHandler<RQ extends Request, RS>(
    RequestHandlerCreator<RQ, RS> creator,
  );

  void registerStreamRequestHandler<RQ extends Request, RS>(
    StreamRequestHandlerCreator<RQ, RS> creator,
  );

  void registerPipelineBehavior<RQ extends Request, RS>(
    PipelineBehaviorCreator<RQ, RS> creator,
  );

  void registerStreamPipelineBehavior<RQ extends Request, RS>(
    StreamPipelineBehaviorCreator<RQ, RS> creator,
  );

  Future<RS> send<RS>(Request<RS> request);

  Stream<RS> createStream<RS>(Request<RS> request);
}
