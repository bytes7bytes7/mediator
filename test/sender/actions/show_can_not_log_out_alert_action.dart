import 'package:mediator/src/sender/behaviors/request_exception_action.dart';
import 'package:mocktail/mocktail.dart';

import '../exceptions/can_not_log_out.dart';
import '../models/auth_result.dart';
import '../requests/log_out_command.dart';

// ignore: missing_override_of_must_be_overridden
class MockShowCanNotLogOutAlertAction extends Mock
    implements
        RequestExceptionAction<AuthResult, LogOutCommand, CanNotLogOut> {}
