import 'package:mediator/src/sender/behaviors/request_pre_processor.dart';
import 'package:mocktail/mocktail.dart';

import '../models/models.dart';
import '../requests/requests.dart';

class MockCheckConnectionPreProcessor extends Mock
    implements RequestPreProcessor<AuthResult, LogOutCommand> {}
