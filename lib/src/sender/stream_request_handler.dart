part of 'sender.dart';

/// [RS] - response.
abstract class StreamRequestHandler<RS, RQ extends StreamRequest<RS>> {
  const StreamRequestHandler();

  Stream<RS> handle(RQ request);
}
