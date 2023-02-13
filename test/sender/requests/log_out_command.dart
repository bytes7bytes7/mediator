import 'package:mediator/mediator.dart';

import '../models/auth_result.dart';

class LogOutCommand extends Request<AuthResult> {
  LogOutCommand() : super(LogOutCommand);
}
