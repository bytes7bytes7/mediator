import 'dart:async';

import '../models/request.dart';
import 'pipeline_behavior.dart';
import 'request_post_processor.dart';

class RequestPostProcessorBehavior<RQ extends Request<RS>, RS>
    implements PipelineBehavior<RQ, RS> {
  const RequestPostProcessorBehavior(this._postProcessors);

  final List<RequestPostProcessor<RQ, RS>> _postProcessors;

  @override
  FutureOr<RS> handle(RQ request, RequestHandlerDelegate<RS> next) async {
    final response = await next();

    for (final processor in _postProcessors) {
      await processor.process(request, response);
    }

    return response;
  }
}
