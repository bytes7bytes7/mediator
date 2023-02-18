import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'exception_handlers/exception_handlers.dart';
import 'exceptions/exceptions.dart';
import 'models/models.dart';
import 'request_handlers/request_handlers.dart';
import 'requests/requests.dart';

void main() {
  late Sender sender;
  late LogInCommand logInCommand;
  late RequestHandler<AuthResult, LogInCommand> logInHandler;
  late RequestExceptionHandler<AuthResult, LogInCommand, EmptyName>
      emptyNameExceptionHandler;
  late RequestExceptionHandler<AuthResult, LogInCommand, EmptyName>
      anotherEmptyNameExceptionHandler;
  late RequestExceptionHandler<AuthResult, LogOutCommand, CanNotLogOut>
      canNotLogOutExceptionHandler;
  late RequestExceptionHandlerState<AuthResult> emptyNameHandlerState;

  setUpAll(() {
    registerFallbackValue(LogInCommand(name: '', password: ''));
    registerFallbackValue(RequestExceptionHandlerState<AuthResult>());
  });

  setUp(() {
    sender = Mediator();
    logInCommand = LogInCommand(name: '', password: '');
    logInHandler = MockLogInCommandHandler();
    emptyNameExceptionHandler = MockEmptyNameExceptionHandler();
    anotherEmptyNameExceptionHandler = MockEmptyNameExceptionHandler();
    canNotLogOutExceptionHandler = MockCanNotLogOutExceptionHandler();
    emptyNameHandlerState = RequestExceptionHandlerState(
      isHandled: true,
      response: AuthResult(false),
    );
  });

  group(
    '$RequestExceptionProcessorBehavior',
    () {
      test(
        '$RequestExceptionHandlerState handles exception thrown by'
        ' a $RequestHandler',
        () async {
          when(() => logInHandler.handle(any())).thenThrow(EmptyName());
          when(() => emptyNameExceptionHandler.handle(any(), any(), any()))
              .thenReturn(emptyNameHandlerState);

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestExceptionProcessorBehavior(
                [emptyNameExceptionHandler],
              ),
            );

          await expectLater(
            logInCommand.sendTo(sender),
            completion(emptyNameHandlerState.response),
          );
        },
      );

      test(
        'Only one $RequestExceptionHandler handles exception'
        ' thrown by a $RequestHandler',
        () async {
          when(() => logInHandler.handle(any())).thenThrow(EmptyName());
          when(() => emptyNameExceptionHandler.handle(any(), any(), any()))
              .thenReturn(emptyNameHandlerState);

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestExceptionProcessorBehavior(
                [
                  emptyNameExceptionHandler,
                  anotherEmptyNameExceptionHandler,
                ],
              ),
            );

          await logInCommand.sendTo(sender);

          verifyNever(
            () => anotherEmptyNameExceptionHandler.handle(any(), any(), any()),
          );
        },
      );

      test(
        'A proper $RequestExceptionHandler handles exception'
        ' thrown by a $RequestHandler when multiple'
        ' ${RequestExceptionHandler}s are registered',
        () async {
          when(() => logInHandler.handle(any())).thenThrow(EmptyName());
          when(() => emptyNameExceptionHandler.handle(any(), any(), any()))
              .thenReturn(emptyNameHandlerState);

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestExceptionProcessorBehavior(
                [emptyNameExceptionHandler],
              ),
            )
            ..registerPipelineBehavior(
              () => RequestExceptionProcessorBehavior(
                [canNotLogOutExceptionHandler],
              ),
            );

          await expectLater(
            logInCommand.sendTo(sender),
            completion(emptyNameHandlerState.response),
          );
        },
      );

      test(
        'If one $RequestExceptionHandler can not handle exception'
        ' then another $RequestExceptionHandler tries to handle'
        ' thrown by a $RequestHandler',
        () async {
          when(() => logInHandler.handle(any())).thenThrow(EmptyName());
          when(() => emptyNameExceptionHandler.handle(any(), any(), any()))
              .thenReturn(RequestExceptionHandlerState(isHandled: false));
          when(
            () => anotherEmptyNameExceptionHandler.handle(any(), any(), any()),
          ).thenReturn(emptyNameHandlerState);

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestExceptionProcessorBehavior(
                [
                  emptyNameExceptionHandler,
                  anotherEmptyNameExceptionHandler,
                ],
              ),
            );

          await logInCommand.sendTo(sender);

          verify(
            () => anotherEmptyNameExceptionHandler.handle(any(), any(), any()),
          ).called(1);
        },
      );

      test(
        'If no one of registered ${RequestExceptionHandler}s can not'
        ' handle exception thrown by a $RequestHandler'
        'then exception remains unhandled',
        () async {
          when(() => logInHandler.handle(any())).thenThrow(EmptyName());
          when(() => emptyNameExceptionHandler.handle(any(), any(), any()))
              .thenReturn(RequestExceptionHandlerState(isHandled: false));
          when(
            () => anotherEmptyNameExceptionHandler.handle(any(), any(), any()),
          ).thenThrow(Exception());

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestExceptionProcessorBehavior(
                [
                  emptyNameExceptionHandler,
                  anotherEmptyNameExceptionHandler,
                ],
              ),
            );

          await expectLater(
            () => logInCommand.sendTo(sender),
            throwsA(TypeMatcher<EmptyName>()),
          );
        },
      );
    },
  );
}
