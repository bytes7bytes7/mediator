import '../models/models.dart';

typedef StreamPipelineDelegate<RS> = Stream<RS> Function();

abstract class StreamPipelineBehavior<RQ extends Request, RS> {
  const StreamPipelineBehavior();

  Stream<RS> handle(
    RQ request,
    StreamPipelineDelegate next,
  );
}
