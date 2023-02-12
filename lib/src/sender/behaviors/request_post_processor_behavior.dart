import 'dart:async';

import '../sender.dart';
import 'request_post_processor.dart';

class RequestPostProcessorBehavior<RS, RQ extends Request<RS>>
    implements PipelineBehavior<RS, RQ> {
  const RequestPostProcessorBehavior(this._postProcessors);

  final List<RequestPostProcessor<RS, RQ>> _postProcessors;

  @override
  FutureOr<RS> handle(RQ request, RequestHandlerDelegate<RS> next) async {
    final response = await next();

    for (final processor in _postProcessors) {
      await processor.process(request, response);
    }

    return response;
  }
}
