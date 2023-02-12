import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'handlers/handlers.dart';
import 'models/models.dart';
import 'requests/requests.dart';

void main() {
  late Sender sender;
  late AuthResult authResult;
  late Message message;
  late LogInCommand logInCommand;
  late GetMessagesCommand getMessagesCommand;
  late RequestHandler<AuthResult, LogInCommand> logInHandler;
  late RequestHandler<AuthResult, LogOutCommand> logOutHandler;
  late StreamRequestHandler<Message, GetMessagesCommand> getMessagesHandler;
  late StreamRequestHandler<Message, EditMessageCommand> editMessageHandler;

  setUpAll(() {
    registerFallbackValue(LogInCommand(name: '', password: ''));
    registerFallbackValue(Message('text'));
    registerFallbackValue(GetMessagesCommand());
    registerFallbackValue(EditMessageCommand());
  });

  setUp(() {
    sender = Mediator();
    authResult = AuthResult(false);
    message = Message('text');
    logInCommand = LogInCommand(name: 'name', password: 'password');
    getMessagesCommand = GetMessagesCommand();
    logInHandler = MockLogInCommandHandler();
    logOutHandler = MockLogOutCommandHandler();
    getMessagesHandler = MockGetMessagesCommandHandler();
    editMessageHandler = MockEditMessageCommandHandler();
  });

  group(
    'Sender',
    () {
      test(
        'throws when no request handlers registered',
        () async {
          await expectLater(
            () => logInCommand.sendTo(sender),
            throwsA(
              TypeMatcher<RequestHandlerNotRegistered>(),
            ),
          );
        },
      );

      test(
        'throws when no stream request handlers registered',
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
        'throws when proper request handlers is not registered',
        () async {
          sender.registerRequestHandler(
            RequestHandlerMeta.create(() => logOutHandler),
          );

          await expectLater(
            () => logInCommand.sendTo(sender),
            throwsA(
              TypeMatcher<RequestHandlerNotRegistered>(),
            ),
          );
        },
      );

      test(
        'throws when proper stream request handlers is not registered',
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
        'does not throw when a proper request handler is registered',
        () async {
          when(() => logInHandler.handle(any())).thenReturn(authResult);
          sender.registerRequestHandler(
            RequestHandlerMeta.create(() => logInHandler),
          );

          await expectLater(
            logInCommand.sendTo(sender),
            completion(authResult),
          );
        },
      );

      test(
        'does not throw when a proper stream request handler is registered',
        () async {
          when(() => getMessagesHandler.handle(any()))
              .thenAnswer((_) => Stream.value(message));
          sender.registerStreamRequestHandler(
            StreamRequestHandlerMeta.create(() => getMessagesHandler),
          );

          await expectLater(
            getMessagesCommand.createStream(sender).first,
            completion(message),
          );
        },
      );

      test(
        'first request handler works well when multiple request '
        'handlers are registered',
        () async {
          when(() => logInHandler.handle(any())).thenReturn(authResult);
          sender
            ..registerRequestHandler(
              RequestHandlerMeta.create(() => logInHandler),
            )
            ..registerRequestHandler(
              RequestHandlerMeta.create(() => logOutHandler),
            );

          await expectLater(
            logInCommand.sendTo(sender),
            completion(authResult),
          );
        },
      );

      test(
        'last request handler works well when multiple request '
        'handlers are registered',
        () async {
          when(() => logInHandler.handle(any())).thenReturn(authResult);
          sender
            ..registerRequestHandler(
              RequestHandlerMeta.create(() => logOutHandler),
            )
            ..registerRequestHandler(
              RequestHandlerMeta.create(() => logInHandler),
            );

          await expectLater(
            logInCommand.sendTo(sender),
            completion(authResult),
          );
        },
      );

      test(
        'first stream request handler works well when multiple '
        'stream request handlers are registered',
        () async {
          when(() => getMessagesHandler.handle(any()))
              .thenAnswer((_) => Stream.value(message));
          sender
            ..registerStreamRequestHandler(
              StreamRequestHandlerMeta.create(() => getMessagesHandler),
            )
            ..registerStreamRequestHandler(
              StreamRequestHandlerMeta.create(() => editMessageHandler),
            );

          await expectLater(
            getMessagesCommand.createStream(sender).first,
            completion(message),
          );
        },
      );

      test(
        'last stream request handler works well when multiple '
        'stream request handlers are registered',
        () async {
          when(() => getMessagesHandler.handle(any()))
              .thenAnswer((_) => Stream.value(message));
          sender
            ..registerStreamRequestHandler(
              StreamRequestHandlerMeta.create(() => editMessageHandler),
            )
            ..registerStreamRequestHandler(
              StreamRequestHandlerMeta.create(() => getMessagesHandler),
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
