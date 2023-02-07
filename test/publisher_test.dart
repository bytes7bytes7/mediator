import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class PostLiked extends Notification {}

class MockPostLikedHandler extends Mock
    implements NotificationHandler<PostLiked> {}

void main() {
  late Publisher publisher;
  late NotificationHandler<PostLiked> postLikedHandler;
  late PostLiked postLiked;

  setUpAll(() {
    registerFallbackValue(PostLiked());
  });

  setUp(() {
    publisher = Mediator();
    postLikedHandler = MockPostLikedHandler();
    postLiked = PostLiked();
  });

  group(
    'Publisher',
    () {
      test(
        'throws when no notification handlers registered',
        () async {
          await expectLater(
            publisher.publish(postLiked),
            throwsA(
              TypeMatcher<
                  NotificationHandlerNotRegistered<
                      NotificationHandlerCreator<PostLiked>>>(),
            ),
          );
        },
      );

      test(
        'does not throw when a proper notification handler is registered',
        () async {
          when(() => postLikedHandler.handle(any())).thenReturn(null);
          publisher.registerNotificationHandler(() => postLikedHandler);

          await expectLater(publisher.publish(postLiked), completion(null));
        },
      );
    },
  );
}
