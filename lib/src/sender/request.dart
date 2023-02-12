part of 'sender.dart';

/// [RS] - type of response.
abstract class Request<RS> {
  Request(this._requestType) : _responseType = RS;

  final Type _requestType;
  final Type _responseType;

  Future<RS> sendTo(Sender sender) {
    // ignore: deprecated_member_use_from_same_package
    return sender.send(
      request: this,
      requestType: _requestType,
      responseType: _responseType,
    );
  }
}
