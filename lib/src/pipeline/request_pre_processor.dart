import 'dart:async';

import '../models/request.dart';

abstract class RequestPreProcessor<RQ extends Request> {
  const RequestPreProcessor();

  FutureOr<void> process(RQ request);
}
