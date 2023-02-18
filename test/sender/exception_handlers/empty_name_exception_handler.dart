import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';

import '../exceptions/empty_name.dart';
import '../models/auth_result.dart';
import '../requests/log_in_command.dart';

// ignore: missing_override_of_must_be_overridden
class MockEmptyNameExceptionHandler extends Mock
    implements RequestExceptionHandler<AuthResult, LogInCommand, EmptyName> {}
