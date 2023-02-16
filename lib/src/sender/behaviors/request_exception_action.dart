import 'dart:async';

import 'package:meta/meta.dart';

import '../sender.dart';

abstract class RequestExceptionAction<RS, RQ extends Request<RS>,
    E extends Exception> {
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
