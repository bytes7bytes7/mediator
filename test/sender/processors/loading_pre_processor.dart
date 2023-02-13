import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';

import '../models/models.dart';
import '../requests/requests.dart';

class MockLoadingPreProcessor extends Mock
    implements RequestPreProcessor<AuthResult, LogInCommand> {}
