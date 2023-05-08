part of 'sender.dart';

typedef StreamHandlerDelegate<RS> = FutureOr<Stream<RS>> Function();

abstract class StreamPipelineBehavior<RQ extends StreamRequest<RS>, RS> {
  const StreamPipelineBehavior();

  FutureOr<Stream<RS>> handle(
    RQ request,
    StreamHandlerDelegate<RS> next,
  );
}
