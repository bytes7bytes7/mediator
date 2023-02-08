import '../models/request.dart';
import '../sender.dart';

class RequestHandlerNotRegistered<T extends RequestHandlerCreator<RQ, RS>,
    RQ extends Request<RS>, RS> implements Exception {
  @override
  String toString() => '$T is not registered';
}
