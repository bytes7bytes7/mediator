part of 'sender.dart';

/// [RS] - response.
abstract class StreamRequestHandler<RQ extends StreamRequest<RS>, RS> {
  const StreamRequestHandler();

  Future<Stream<RS>> handle(RQ request);
}
