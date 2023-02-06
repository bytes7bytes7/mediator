import 'dart:async';

import '../models/request.dart';

typedef PipelineDelegate<RS> = FutureOr<RS> Function();

/// [RS] - response.
abstract class PipelineBehavior<RQ extends Request, RS> {
  const PipelineBehavior();

  FutureOr<RS> handle(
    RQ request,
    PipelineDelegate<RS> next,
  );
}
