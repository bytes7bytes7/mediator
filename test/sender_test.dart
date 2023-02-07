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

class LoginCommand extends Request<AuthResult> {
  const LoginCommand({
    required this.name,
    required this.password,
  });

  final String name;
  final String password;
}

class MockLoginCommandHandler extends Mock
    implements RequestHandler<LoginCommand, AuthResult> {}

void main() {
  late Sender sender;
  late RequestHandler<LoginCommand, AuthResult> loginHandler;
  late LoginCommand loginCommand;
  late AuthResult authResult;

  setUpAll(() {
    registerFallbackValue(LoginCommand(name: '', password: ''));
  });

  setUp(() {
    sender = Mediator();
    loginHandler = MockLoginCommandHandler();
    loginCommand = LoginCommand(name: 'name', password: 'password');
    authResult = AuthResult(false);
  });

  group(
    'Sender',
    () {
      test(
        'throws when no request handlers registered',
        () async {
          await expectLater(
            sender.send(loginCommand),
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
        'does not throw when a proper request handler is registered',
        () async {
          when(() => loginHandler.handle(any())).thenReturn(authResult);
          sender.registerRequestHandler(() => loginHandler);

          await expectLater(
            sender.send(loginCommand),
            completion(authResult),
          );
        },
      );
    },
  );
}
