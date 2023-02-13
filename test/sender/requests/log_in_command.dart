import 'package:mediator/mediator.dart';

import '../models/auth_result.dart';

class LogInCommand extends Request<AuthResult> {
  LogInCommand({
    required this.name,
    required this.password,
  }) : super(LogInCommand);

  final String name;
  final String password;
}
