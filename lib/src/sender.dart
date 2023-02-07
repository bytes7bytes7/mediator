import 'handlers/handlers.dart';
import 'models/models.dart';
import 'pipeline/pipeline.dart';

typedef RequestHandlerCreator<RQ extends Request, RS> = RequestHandler<RQ, RS>
    Function();
typedef StreamRequestHandlerCreator<RQ extends StreamRequest, RS>
    = StreamRequestHandler<RQ, RS> Function();
typedef PipelineBehaviorCreator<RQ extends Request, RS>
    = PipelineBehavior<RQ, RS> Function();
typedef StreamPipelineBehaviorCreator<RQ extends StreamRequest, RS>
    = StreamPipelineBehavior<RQ, RS> Function();

abstract class Sender {
  const Sender();

  void registerRequestHandler<RS>(
    RequestHandlerCreator<Request<RS>, RS> creator,
  );

  void registerStreamRequestHandler<RS>(
    StreamRequestHandlerCreator<StreamRequest<RS>, RS> creator,
  );

  void registerPipelineBehavior<RS>(
    PipelineBehaviorCreator<Request<RS>, RS> creator,
  );

  void registerStreamPipelineBehavior<RS>(
    StreamPipelineBehaviorCreator<StreamRequest<RS>, RS> creator,
  );

  Future<RS> send<RS>(Request<RS> request);

  Stream<RS> createStream<RS>(StreamRequest<RS> request);
}
