import 'dart:async';

import '../models/request.dart';
import 'pipeline_behavior.dart';
import 'request_pre_processor.dart';

class RequestPreProcessorBehavior<RQ extends Request, RS>
    implements PipelineBehavior<RQ, RS> {
  const RequestPreProcessorBehavior(this._preProcessors);

  final List<RequestPreProcessor<RQ>> _preProcessors;

  @override
  FutureOr<RS> handle(RQ request, PipelineDelegate<RS> next) async {
    for (final processor in _preProcessors) {
      await processor.process(request);
    }

    return await next();
  }
}
