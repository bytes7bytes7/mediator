import 'models/request.dart';

/// [RS] - response.
abstract class StreamRequestHandler<RQ extends Request, RS> {
  const StreamRequestHandler();

  Stream<RS> handle(RQ request);
}
