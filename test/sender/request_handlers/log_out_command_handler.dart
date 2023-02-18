import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';

import '../models/auth_result.dart';
import '../requests/log_out_command.dart';

class MockLogOutCommandHandler extends Mock
    implements RequestHandler<AuthResult, LogOutCommand> {}
