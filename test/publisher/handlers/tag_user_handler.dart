import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';

import '../notifications/tag_user.dart';

class MockTagUserHandler extends Mock implements NotificationHandler<TagUser> {}
