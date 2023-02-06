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

  void registerRequestHandler<RS>(
    RequestHandlerCreator<Request<RS>, RS> creator,
  );

  void registerStreamRequestHandler<RS>(
    StreamRequestHandlerCreator<Request<RS>, RS> creator,
  );

  void registerPipelineBehavior<RS>(
    PipelineBehaviorCreator<Request<RS>, RS> creator,
  );

  void registerStreamPipelineBehavior<RS>(
    StreamPipelineBehaviorCreator<Request<RS>, RS> creator,
  );

  Future<RS> send<RS>(Request<RS> request);

  Stream<RS> createStream<RS>(Request<RS> request);
}
