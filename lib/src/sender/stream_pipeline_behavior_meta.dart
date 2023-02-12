part of 'sender.dart';

class StreamPipelineBehaviorMeta {
  StreamPipelineBehaviorMeta._({
    required this.behaviorCreator,
    required this.requestType,
  });

  final StreamPipelineBehaviorCreator behaviorCreator;

  final Type requestType;

  static StreamPipelineBehaviorMeta create<RS, RQ extends StreamRequest<RS>>(
    StreamPipelineBehaviorCreator<RS, RQ> behaviorCreator,
  ) {
    return StreamPipelineBehaviorMeta._(
      behaviorCreator: behaviorCreator,
      requestType: RQ,
    );
  }
}
