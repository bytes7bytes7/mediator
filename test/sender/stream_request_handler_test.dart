import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'handlers/handlers.dart';
import 'models/models.dart';
import 'requests/requests.dart';

void main() {
  late Sender sender;
  late Message message;
  late GetMessagesCommand getMessagesCommand;
  late StreamRequestHandler<Message, GetMessagesCommand> getMessagesHandler;
  late StreamRequestHandler<Message, EditMessageCommand> editMessageHandler;

  setUpAll(() {
    registerFallbackValue(GetMessagesCommand());
  });

  setUp(() {
    sender = Mediator();
    message = Message('text');
    getMessagesCommand = GetMessagesCommand();
    getMessagesHandler = MockGetMessagesCommandHandler();
    editMessageHandler = MockEditMessageCommandHandler();
  });

  group(
    '$StreamRequestHandler',
    () {
      test(
        'throws when no $StreamRequestHandler is registered',
        () async {
          await expectLater(
            () => getMessagesCommand.createStream(sender),
            throwsA(
              TypeMatcher<StreamRequestHandlerNotRegistered>(),
            ),
          );
        },
      );

      test(
        'throws when a proper $StreamRequestHandler is not registered',
        () async {
          await expectLater(
            () => getMessagesCommand.createStream(sender),
            throwsA(
              TypeMatcher<StreamRequestHandlerNotRegistered>(),
            ),
          );
        },
      );

      test(
        'does not throw when a proper $StreamRequestHandler is registered',
        () async {
          when(() => getMessagesHandler.handle(any()))
              .thenAnswer((_) => Stream.value(message));

          sender.registerStreamRequestHandler(
            () => getMessagesHandler,
          );

          await expectLater(
            getMessagesCommand.createStream(sender).first,
            completion(message),
          );
        },
      );

      test(
        'first $StreamRequestHandler works well when multiple '
        '${StreamRequestHandler}s are registered',
        () async {
          when(() => getMessagesHandler.handle(any()))
              .thenAnswer((_) => Stream.value(message));

          sender
            ..registerStreamRequestHandler(
              () => getMessagesHandler,
            )
            ..registerStreamRequestHandler(
              () => editMessageHandler,
            );

          await expectLater(
            getMessagesCommand.createStream(sender).first,
            completion(message),
          );
        },
      );

      test(
        'last $StreamRequestHandler works well when multiple '
        '${StreamRequestHandler}s are registered',
        () async {
          when(() => getMessagesHandler.handle(any()))
              .thenAnswer((_) => Stream.value(message));

          sender
            ..registerStreamRequestHandler(
              () => editMessageHandler,
            )
            ..registerStreamRequestHandler(
              () => getMessagesHandler,
            );

          await expectLater(
            getMessagesCommand.createStream(sender).first,
            completion(message),
          );
        },
      );
    },
  );
}
