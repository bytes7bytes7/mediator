class StreamRequestHandlerNotRegistered implements Exception {
  const StreamRequestHandlerNotRegistered({
    required this.requestType,
    required this.responseType,
  });

  final Type requestType;
  final Type responseType;

  @override
  String toString() =>
      'StreamRequestHandler<$requestType, $responseType> is not registered';
}
