import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';

import '../models/models.dart';
import '../requests/requests.dart';

class MockLogOutCommandHandler extends Mock
    implements RequestHandler<LogOutCommand, AuthResult> {}
