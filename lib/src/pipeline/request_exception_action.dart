import 'dart:async';

import 'package:meta/meta.dart';

import '../models/request.dart';

abstract class RequestExceptionAction<RQ extends Request, E extends Exception> {
  const RequestExceptionAction();

  /// Call the super method first.
  @mustCallSuper
  @mustBeOverridden
  FutureOr<void> execute(RQ request, Object exception) async {
    if (exception is! E) {
      throw Exception('$exception is not $E');
    }
  }
}
