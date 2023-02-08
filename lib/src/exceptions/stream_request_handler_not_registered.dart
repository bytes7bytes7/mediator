import '../models/stream_request.dart';
import '../sender.dart';

class StreamRequestHandlerNotRegistered<
    T extends StreamRequestHandlerCreator<RQ, RS>,
    RQ extends StreamRequest<RS>,
    RS> implements Exception {
  @override
  String toString() => '$T is not registered';
}
