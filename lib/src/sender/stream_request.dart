part of 'sender.dart';

/// [RS] - type of response.
abstract class StreamRequest<RS> {
  StreamRequest(this._requestType) : _responseType = RS;

  final Type _requestType;
  final Type _responseType;

  Future<Stream<RS>> createStream(Sender sender) {
    // ignore: deprecated_member_use_from_same_package
    return sender.createStream(
      request: this,
      requestType: _requestType,
      responseType: _responseType,
    );
  }
}
