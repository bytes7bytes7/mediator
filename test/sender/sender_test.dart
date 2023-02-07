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
  late LogOutCommand logOutCommand;
  late GetMessagesCommand getMessagesCommand;
  late RequestHandler<LogInCommand, AuthResult> logInHandler;
  late RequestHandler<LogOutCommand, AuthResult> logOutHandler;
  late StreamRequestHandler<GetMessagesCommand, Message> getMessagesHandler;

  setUpAll(() {
    registerFallbackValue(LogInCommand(name: '', password: ''));
    registerFallbackValue(Message('text'));
  });

  setUp(() {
    sender = Mediator();
    authResult = AuthResult(false);
    message = Message('text');
    logInCommand = LogInCommand(name: 'name', password: 'password');
    logOutCommand = LogOutCommand();
    getMessagesCommand = GetMessagesCommand();
    logInHandler = MockLogInCommandHandler();
    logOutHandler = MockLogOutCommandHandler();
    getMessagesHandler = MockGetMessagesCommandHandler();
  });

  group(
    'Sender',
    () {
      test(
        'throws when no request handlers registered',
        () async {
          await expectLater(
            () => sender.send(logInCommand),
            throwsA(
              TypeMatcher<
                  RequestHandlerNotRegistered<
                      RequestHandlerCreator<Request<AuthResult>,
                          AuthResult>>>(),
            ),
          );
        },
      );

      test(
        'throws when no stream request handlers registered',
        () async {
          await expectLater(
            () => sender.createStream(getMessagesCommand),
            throwsA(
              TypeMatcher<
                  StreamRequestHandlerNotRegistered<
                      StreamRequestHandlerCreator<StreamRequest<AuthResult>,
                          AuthResult>>>(),
            ),
          );
        },
      );

      test(
        'throws when proper request handlers is not registered',
        () async {
          sender.registerRequestHandler(() => logOutHandler);

          await expectLater(
            () => sender.send(logInCommand),
            throwsA(
              TypeMatcher<
                  RequestHandlerNotRegistered<
                      RequestHandlerCreator<Request<AuthResult>,
                          AuthResult>>>(),
            ),
          );
        },
      );

      test(
        'throws when proper stream request handlers is not registered',
        () async {
          await expectLater(
            () => sender.createStream(getMessagesCommand),
            throwsA(
              TypeMatcher<
                  StreamRequestHandlerNotRegistered<
                      StreamRequestHandlerCreator<StreamRequest<AuthResult>,
                          AuthResult>>>(),
            ),
          );
        },
      );

      test(
        'does not throw when a proper request handler is registered',
        () async {
          when(() => logInHandler.handle(any())).thenReturn(authResult);
          sender.registerRequestHandler(() => logInHandler);

          await expectLater(
            sender.send(logInCommand),
            completion(authResult),
          );
        },
      );
    },
  );
}
