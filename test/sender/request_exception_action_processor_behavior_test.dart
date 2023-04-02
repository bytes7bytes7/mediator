import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'actions/actions.dart';
import 'exceptions/exceptions.dart';
import 'models/models.dart';
import 'request_handlers/request_handlers.dart';
import 'requests/requests.dart';

void main() {
  late Sender sender;
  late LogInCommand logInCommand;
  late RequestHandler<LogInCommand, AuthResult> logInHandler;
  late RequestExceptionAction<LogInCommand, EmptyName, AuthResult>
      showEmptyNameAlertAction;
  late RequestExceptionAction<LogInCommand, EmptyName, AuthResult>
      showEmptyNameTextFieldErrorAction;
  late RequestExceptionAction<LogOutCommand, CanNotLogOut, AuthResult>
      showCanNotLogOutAlert;

  setUpAll(() {
    registerFallbackValue(LogInCommand(name: '', password: ''));
    registerFallbackValue(EmptyName());
  });

  setUp(() {
    sender = Mediator();
    logInCommand = LogInCommand(name: '', password: '');
    logInHandler = MockLogInCommandHandler();
    showEmptyNameAlertAction = MockShowEmptyNameAlertAction();
    showEmptyNameTextFieldErrorAction = MockShowEmptyNameTextFieldErrorAction();
    showCanNotLogOutAlert = MockShowCanNotLogOutAlertAction();
  });

  group(
    '$RequestExceptionActionProcessorBehavior',
    () {
      test(
        '$RequestExceptionAction works after $RequestHandler throws',
        () async {
          final events = <String>[];
          final emptyNameEvent = 'empty name';

          when(() => logInHandler.handle(any())).thenThrow(EmptyName());
          when(() => showEmptyNameAlertAction.execute(any(), any()))
              .thenAnswer((_) => events.add(emptyNameEvent));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestExceptionActionProcessorBehavior(
                [showEmptyNameAlertAction.wrapper],
              ),
            );

          try {
            await logInCommand.sendTo(sender);
          } catch (_) {}

          expect(events, [emptyNameEvent]);
        },
      );

      test(
        'All ${RequestExceptionAction}s in the same'
        ' $RequestExceptionActionProcessorBehavior work after'
        ' $RequestHandler throws',
        () async {
          final events = <String>[];
          final emptyNameAlert = 'empty name alert';
          final emptyNameTextFieldError = 'empty name text field error';

          when(() => logInHandler.handle(any())).thenThrow(EmptyName());
          when(() => showEmptyNameAlertAction.execute(any(), any()))
              .thenAnswer((_) => events.add(emptyNameAlert));
          when(() => showEmptyNameTextFieldErrorAction.execute(any(), any()))
              .thenAnswer((_) => events.add(emptyNameTextFieldError));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestExceptionActionProcessorBehavior(
                [
                  showEmptyNameAlertAction.wrapper,
                  showEmptyNameTextFieldErrorAction.wrapper,
                ],
              ),
            );

          try {
            await logInCommand.sendTo(sender);
          } catch (_) {}

          expect(events, [emptyNameAlert, emptyNameTextFieldError]);
        },
      );

      test(
        'A proper $RequestExceptionActionProcessorBehavior works when'
        ' multiple ${RequestExceptionActionProcessorBehavior}s are registered',
        () async {
          final events = <String>[];
          final emptyNameAlert = 'empty name alert';

          when(() => logInHandler.handle(any())).thenThrow(EmptyName());
          when(() => showEmptyNameAlertAction.execute(any(), any()))
              .thenAnswer((_) => events.add(emptyNameAlert));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestExceptionActionProcessorBehavior(
                [
                  showEmptyNameAlertAction.wrapper,
                ],
              ),
            )
            ..registerPipelineBehavior(
              () => RequestExceptionActionProcessorBehavior(
                [showCanNotLogOutAlert.wrapper],
              ),
            );

          try {
            await logInCommand.sendTo(sender);
          } catch (_) {}

          expect(events, [emptyNameAlert]);
        },
      );

      test(
        'All ${RequestExceptionAction}s in different'
        ' ${RequestExceptionActionProcessorBehavior}s work in order opposite'
        ' to registering order after'
        ' $RequestHandler throws',
        () async {
          final events = <String>[];
          final emptyNameAlert = 'empty name alert';
          final emptyNameTextFieldError = 'empty name text field error';

          when(() => logInHandler.handle(any())).thenThrow(EmptyName());
          when(() => showEmptyNameAlertAction.execute(any(), any()))
              .thenAnswer((_) => events.add(emptyNameAlert));
          when(() => showEmptyNameTextFieldErrorAction.execute(any(), any()))
              .thenAnswer((_) => events.add(emptyNameTextFieldError));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestExceptionActionProcessorBehavior(
                [showEmptyNameAlertAction.wrapper],
              ),
            )
            ..registerPipelineBehavior(
              () => RequestExceptionActionProcessorBehavior(
                [showEmptyNameTextFieldErrorAction.wrapper],
              ),
            );

          try {
            await logInCommand.sendTo(sender);
          } catch (_) {}

          expect(events, [
            emptyNameTextFieldError,
            emptyNameAlert,
          ]);
        },
      );
    },
  );
}
