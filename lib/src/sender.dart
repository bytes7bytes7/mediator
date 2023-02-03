import 'models/request.dart';

abstract class Sender {
  const Sender();

  Future<RS> send<RS>(Request<RS> request);

  Stream<RS> createStream<RS>(Request<RS> request);
}
