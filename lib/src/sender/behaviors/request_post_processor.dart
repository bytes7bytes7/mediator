import 'dart:async';

import '../sender.dart';

abstract class RequestPostProcessor<RS, RQ extends Request<RS>> {
  const RequestPostProcessor();

  FutureOr<void> process(RQ request, RS response);
}
