import 'package:mediator/mediator.dart';

import '../models/models.dart';

class LogInCommand extends Request<AuthResult> {
  const LogInCommand({
    required this.name,
    required this.password,
  });

  final String name;
  final String password;
}
