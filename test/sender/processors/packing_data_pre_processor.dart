import 'package:mediator/src/sender/behaviors/behaviors.dart';
import 'package:mocktail/mocktail.dart';

import '../models/models.dart';
import '../requests/requests.dart';

class MockPackingDataPreProcessor extends Mock
    implements RequestPreProcessor<AuthResult, LogInCommand> {}
