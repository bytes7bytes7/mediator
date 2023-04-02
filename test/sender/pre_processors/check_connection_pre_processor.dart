import 'package:mediator/src/sender/behaviors/request_pre_processor.dart';
import 'package:mocktail/mocktail.dart';

import '../models/auth_result.dart';
import '../requests/log_out_command.dart';

class MockCheckConnectionPreProcessor extends Mock
    implements RequestPreProcessor<LogOutCommand, AuthResult> {}
