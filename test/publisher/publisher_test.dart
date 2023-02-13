import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'handlers/handlers.dart';
import 'notifications/notifications.dart';

void main() {
  late Publisher publisher;
  late PostLiked postLiked;
  late NotificationHandler<PostLiked> postLikedHandler;
  late NotificationHandler<TagUser> tagUserHandler;

  setUpAll(() {
    registerFallbackValue(PostLiked());
  });

  setUp(() {
    publisher = Mediator();
    postLiked = PostLiked();
    postLikedHandler = MockPostLikedHandler();
    tagUserHandler = MockTagUserHandler();
  });

  group(
    'Publisher',
    () {
      test(
        'throws when no $NotificationHandler is registered',
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
        'throws when a proper $NotificationHandler is not registered',
        () async {
          publisher.registerNotificationHandler(() => tagUserHandler);

          await expectLater(
            () => postLiked.publishTo(publisher),
            throwsA(
              TypeMatcher<NotificationHandlerNotRegistered>(),
            ),
          );
        },
      );

      test(
        'does not throw when a proper $NotificationHandler is registered',
        () async {
          when(() => postLikedHandler.handle(any())).thenReturn(null);
          publisher.registerNotificationHandler(() => postLikedHandler);

          await expectLater(
            () => postLiked.publishTo(publisher),
            returnsNormally,
          );
        },
      );

      test(
        'first $NotificationHandler works well when multiple'
        ' ${NotificationHandler}s are registered',
        () async {
          when(() => postLikedHandler.handle(any())).thenReturn(null);
          publisher
            ..registerNotificationHandler(() => postLikedHandler)
            ..registerNotificationHandler(() => tagUserHandler);

          await expectLater(
            () => postLiked.publishTo(publisher),
            returnsNormally,
          );
        },
      );

      test(
        'last $NotificationHandler works well when multiple'
        ' ${NotificationHandler}s are registered',
        () async {
          when(() => postLikedHandler.handle(any())).thenReturn(null);
          publisher
            ..registerNotificationHandler(() => tagUserHandler)
            ..registerNotificationHandler(() => postLikedHandler);

          await expectLater(
            () => postLiked.publishTo(publisher),
            returnsNormally,
          );
        },
      );
    },
  );
}
