import 'handlers/handlers.dart';
import 'models/models.dart';
import 'pipeline/pipeline.dart';

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

  Future<RS> send<RQ extends Request<RS>, RS>(RQ request);

  Stream<RS> createStream<RQ extends StreamRequest<RS>, RS>(RQ request);
}
