part of 'sender.dart';

class PipelineBehaviorMeta {
  PipelineBehaviorMeta._({
    required this.behaviorCreator,
    required this.requestType,
  });

  final PipelineBehaviorCreator behaviorCreator;

  final Type requestType;

  static PipelineBehaviorMeta create<RS, RQ extends Request<RS>>(
    PipelineBehaviorCreator<RS, RQ> behaviorCreator,
  ) {
    return PipelineBehaviorMeta._(
      behaviorCreator: behaviorCreator,
      requestType: RQ,
    );
  }
}
