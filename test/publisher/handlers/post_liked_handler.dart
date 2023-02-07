import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';

import '../notifications/notifications.dart';

class MockPostLikedHandler extends Mock
    implements NotificationHandler<PostLiked> {}
