import 'models/request.dart';

abstract class Sender {
  const Sender();

  Future<R> send<R>(Request<R> request);

  Stream<R> createStream<R>(Request<R> request);
}
