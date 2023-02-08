import 'dart:async';

import '../models/request.dart';

/// [RS] - response.
abstract class RequestHandler<RQ extends Request<RS>, RS> {
  const RequestHandler();

  FutureOr<RS> handle(RQ request);
}
