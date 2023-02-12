import 'package:mediator/mediator.dart';

import '../models/models.dart';

class LogInCommand extends Request<AuthResult> {
  LogInCommand({
    required this.name,
    required this.password,
  }) : super(LogInCommand);

  final String name;
  final String password;
}
