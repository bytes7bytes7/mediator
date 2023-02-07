import '../sender.dart';

class StreamRequestHandlerNotRegistered<T extends StreamRequestHandlerCreator>
    implements Exception {
  @override
  String toString() => '$T is not registered';
}
