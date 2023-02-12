part of 'sender.dart';

typedef RequestHandlerDelegate<RS> = FutureOr<RS> Function();

/// [RS] - response.
abstract class PipelineBehavior<RS, RQ extends Request<RS>> {
  const PipelineBehavior();

  FutureOr<RS> handle(
    RQ request,
    RequestHandlerDelegate<RS> next,
  );
}
