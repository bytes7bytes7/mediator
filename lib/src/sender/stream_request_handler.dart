part of 'sender.dart';

/// [RS] - response.
abstract class StreamRequestHandler<RQ extends StreamRequest<RS>, RS> {
  const StreamRequestHandler();

  Stream<RS> handle(RQ request);
}
