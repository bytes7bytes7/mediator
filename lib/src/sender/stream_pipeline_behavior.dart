part of 'sender.dart';

typedef StreamHandlerDelegate<RS> = Stream<RS> Function();

abstract class StreamPipelineBehavior<RQ extends StreamRequest<RS>, RS> {
  const StreamPipelineBehavior();

  Stream<RS> handle(
    RQ request,
    StreamHandlerDelegate<RS> next,
  );
}
