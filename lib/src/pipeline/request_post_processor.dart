import 'dart:async';

import '../models/request.dart';

abstract class RequestPostProcessor<RQ extends Request, RS> {
  const RequestPostProcessor();

  FutureOr<void> process(RQ request, RS response);
}
