import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'handlers/handlers.dart';
import 'models/models.dart';
import 'requests/requests.dart';

void main() {
  late Sender sender;
  late AuthResult authResult;
  late LogInCommand logInCommand;
  late RequestHandler<AuthResult, LogInCommand> logInHandler;
  late RequestHandler<AuthResult, LogOutCommand> logOutHandler;

  setUpAll(() {
    registerFallbackValue(LogInCommand(name: '', password: ''));
    registerFallbackValue(Message('text'));
    registerFallbackValue(GetMessagesCommand());
    registerFallbackValue(EditMessageCommand());
  });

  setUp(() {
    sender = Mediator();
    authResult = AuthResult(false);
    logInCommand = LogInCommand(name: 'name', password: 'password');
    logInHandler = MockLogInCommandHandler();
    logOutHandler = MockLogOutCommandHandler();
  });

  group(
    '$RequestHandler',
    () {
      test(
        'throws when no $RequestHandler is registered',
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
        'throws when a roper $RequestHandler is not registered',
        () async {
          sender.registerRequestHandler(
            () => logOutHandler,
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
        'does not throw when a proper $RequestHandler is registered',
        () async {
          when(() => logInHandler.handle(any())).thenReturn(authResult);

          sender.registerRequestHandler(
            () => logInHandler,
          );

          await expectLater(
            logInCommand.sendTo(sender),
            completion(authResult),
          );
        },
      );

      test(
        'first $RequestHandler works well when multiple ${RequestHandler}s'
        ' are registered',
        () async {
          when(() => logInHandler.handle(any())).thenReturn(authResult);

          sender
            ..registerRequestHandler(
              () => logInHandler,
            )
            ..registerRequestHandler(
              () => logOutHandler,
            );

          await expectLater(
            logInCommand.sendTo(sender),
            completion(authResult),
          );
        },
      );

      test(
        'last $RequestHandler works well when multiple ${RequestHandler}s'
        ' are registered',
        () async {
          when(() => logInHandler.handle(any())).thenReturn(authResult);

          sender
            ..registerRequestHandler(
              () => logOutHandler,
            )
            ..registerRequestHandler(
              () => logInHandler,
            );

          await expectLater(
            logInCommand.sendTo(sender),
            completion(authResult),
          );
        },
      );
    },
  );
}
