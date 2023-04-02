import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'sender/exception_handlers/exception_handlers.dart';
import 'sender/exceptions/exceptions.dart';
import 'sender/models/models.dart';
import 'sender/request_handlers/request_handlers.dart';
import 'sender/requests/requests.dart';

void main() {
  late Sender sender;
  late LogInCommand logInCommand;
  late LogInWithEmailCommand logInWithEmailCommand;
  late RequestHandler<LogInCommand, AuthResult> logInHandler;
  late RequestExceptionHandler<LogInCommand, Exception, AuthResult>
      commonExceptionHandler;
  late AuthResult authResult;

  setUpAll(() {
    registerFallbackValue(LogInCommand(name: 'name', password: 'password'));
    registerFallbackValue(EmptyName());
    registerFallbackValue(RequestExceptionHandlerState<AuthResult>());
  });

  setUp(() {
    sender = Mediator();
    logInCommand = LogInCommand(name: '', password: '');
    logInWithEmailCommand =
        LogInWithEmailCommand(name: 'name', password: 'password');
    logInHandler = MockLogInCommandHandler();
    commonExceptionHandler = MockCommonExceptionHandler();
    authResult = AuthResult(false);
  });

  group(
    'Common',
    () {
      test(
        '$RequestExceptionHandler for handling all types of $Exception',
        () async {
          when(() => logInHandler.handle(any())).thenThrow(EmptyName());
          when(() => commonExceptionHandler.handle(any(), any(), any()))
              .thenReturn(
            RequestExceptionHandlerState(
              isHandled: true,
              response: authResult,
            ),
          );

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestExceptionProcessorBehavior(
                [
                  commonExceptionHandler.wrapper,
                ],
              ),
            );

          await expectLater(
            logInCommand.sendTo(sender),
            completion(authResult),
          );
        },
      );

      test(
        'A proper ${RequestHandler<LogInCommand, AuthResult>} handles an '
        'inheritor of $LogInCommand',
        () async {
          when(() => logInHandler.handle(any())).thenReturn(authResult);

          sender.registerRequestHandler(() => logInHandler);

          await expectLater(
            logInWithEmailCommand.sendTo(sender),
            completion(authResult),
          );
        },
      );
    },
  );
}
