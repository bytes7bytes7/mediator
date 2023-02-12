import '../sender.dart';

class RequestHandlerNotRegistered implements Exception {
  const RequestHandlerNotRegistered({
    required this.requestType,
    required this.responseType,
  });

  final Type requestType;
  final Type responseType;

  @override
  String toString() =>
      '$RequestHandler<$requestType, $responseType> is not registered';
}
