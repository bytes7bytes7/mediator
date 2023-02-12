part of 'sender.dart';

/// [RS] - response.
abstract class RequestHandler<RS, RQ extends Request<RS>> {
  const RequestHandler();

  FutureOr<RS> handle(RQ request);
}
