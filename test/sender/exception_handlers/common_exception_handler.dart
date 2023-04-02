import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';

import '../models/auth_result.dart';
import '../requests/log_in_command.dart';

class MockCommonExceptionHandler extends Mock
    implements RequestExceptionHandler<LogInCommand, Exception, AuthResult> {}
