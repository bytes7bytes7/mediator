import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';

import '../notifications/post_liked.dart';

class MockPostLikedHandler extends Mock
    implements NotificationHandler<PostLiked> {}
