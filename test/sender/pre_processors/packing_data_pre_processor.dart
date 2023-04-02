import 'package:mediator/src/sender/behaviors/behaviors.dart';
import 'package:mocktail/mocktail.dart';

import '../models/auth_result.dart';
import '../requests/log_in_command.dart';

class MockPackingDataPreProcessor extends Mock
    implements RequestPreProcessor<LogInCommand, AuthResult> {}
