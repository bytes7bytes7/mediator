import 'dart:async';

import '../sender.dart';

abstract class RequestPreProcessor<RS, RQ extends Request<RS>> {
  const RequestPreProcessor();

  FutureOr<void> process(RQ request);
}
