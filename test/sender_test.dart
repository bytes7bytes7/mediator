import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class AuthResult {
  const AuthResult(
    this.isLoggedIn, {
    this.error = '',
  });

  final bool isLoggedIn;
  final String error;

  @override
  String toString() => '$AuthResult {isLoggedIn: $isLoggedIn, error: $error}';
}

class LogInCommand extends Request<AuthResult> {
  const LogInCommand({
    required this.name,
    required this.password,
  });

  final String name;
  final String password;
}

class LogOutCommand extends Request<AuthResult> {}

class GetMessagesCommand extends Request

class MockLogInCommandHandler extends Mock
    implements RequestHandler<LogInCommand, AuthResult> {}

class MockLogOutCommandHandler extends Mock
    implements RequestHandler<LogOutCommand, AuthResult> {}

class MockGetMessagesCommandHandler extends Mock implements StreamRequestHandler<> {}

void main() {
  late Sender sender;
  late LogInCommand logInCommand;
  late LogOutCommand logOutCommand;
  late AuthResult authResult;
  late RequestHandler<LogInCommand, AuthResult> logInHandler;
  late RequestHandler<LogOutCommand, AuthResult> logOutHandler;

  setUpAll(() {
    registerFallbackValue(LogInCommand(name: '', password: ''));
  });

  setUp(() {
    sender = Mediator();
    logInCommand = LogInCommand(name: 'name', password: 'password');
    logOutCommand = LogOutCommand();
    authResult = AuthResult(false);
    logInHandler = MockLogInCommandHandler();
    logOutHandler = MockLogOutCommandHandler();
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
            () => sender.createStream(logInCommand),
            throwsA(
              TypeMatcher<
                  StreamRequestHandlerNotRegistered<
                      StreamRequestHandlerCreator<Request<AuthResult>,
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
            () => sender.createStream(logInCommand),
            throwsA(
              TypeMatcher<
                  StreamRequestHandlerNotRegistered<
                      StreamRequestHandlerCreator<Request<AuthResult>,
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
