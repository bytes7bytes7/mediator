import '../sender.dart';

class RequestHandlerNotRegistered<T extends RequestHandlerCreator>
    implements Exception {
  @override
  String toString() => '$T is not registered';
}
