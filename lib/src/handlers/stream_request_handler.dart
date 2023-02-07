import '../models/stream_request.dart';

/// [RS] - response.
abstract class StreamRequestHandler<RQ extends StreamRequest, RS> {
  const StreamRequestHandler();

  Stream<RS> handle(RQ request);
}
