import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'handlers/handlers.dart';
import 'notifications/notifications.dart';

void main() {
  late Publisher publisher;
  late PostLiked postLiked;
  late NotificationHandler<PostLiked> postLikedHandler;

  setUpAll(() {
    registerFallbackValue(PostLiked());
  });

  setUp(() {
    publisher = Mediator();
    postLiked = PostLiked();
    postLikedHandler = MockPostLikedHandler();
  });

  group(
    'Publisher',
    () {
      test(
        'throws when no notification handlers registered',
        () async {
          await expectLater(
            () => postLiked.publishTo(publisher),
            throwsA(
              TypeMatcher<NotificationHandlerNotRegistered>(),
            ),
          );
        },
      );

      test(
        'does not throw when a proper notification handler is registered',
        () async {
          when(() => postLikedHandler.handle(any())).thenReturn(null);
          publisher.registerNotificationHandler(() => postLikedHandler);

          await expectLater(
            () => postLiked.publishTo(publisher),
            returnsNormally,
          );
        },
      );
    },
  );
}
