import 'dart:async';

import '../sender.dart';

abstract class RequestPostProcessor<RQ extends Request<RS>, RS> {
  const RequestPostProcessor();

  FutureOr<void> process(RQ request, RS response);
}
