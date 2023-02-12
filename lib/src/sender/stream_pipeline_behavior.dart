part of 'sender.dart';

typedef StreamHandlerDelegate<RS> = Stream<RS> Function();

abstract class StreamPipelineBehavior<RS, RQ extends StreamRequest<RS>> {
  const StreamPipelineBehavior();

  Stream<RS> handle(
    RQ request,
    StreamHandlerDelegate next,
  );
}
