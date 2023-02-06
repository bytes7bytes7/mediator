import '../models/models.dart';

typedef StreamHandlerDelegate<RS> = Stream<RS> Function();

abstract class StreamPipelineBehavior<RQ extends Request, RS> {
  const StreamPipelineBehavior();

  Stream<RS> handle(
    RQ request,
    StreamHandlerDelegate next,
  );
}
