import 'dart:async';

import '../sender.dart';

abstract class RequestPreProcessor<RQ extends Request<RS>, RS> {
  const RequestPreProcessor();

  FutureOr<void> process(RQ request);
}
