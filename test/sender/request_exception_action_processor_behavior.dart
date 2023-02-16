import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'actions/actions.dart';
import 'exceptions/exceptions.dart';
import 'handlers/handlers.dart';
import 'models/models.dart';
import 'requests/requests.dart';

void main() {
  late Sender sender;
  late LogInCommand logInCommand;
  late RequestHandler<AuthResult, LogInCommand> logInHandler;
  late RequestExceptionAction<AuthResult, LogInCommand, EmptyName>
      emptyNameAction;

  setUpAll(() {
    registerFallbackValue(LogInCommand(name: '', password: ''));
  });

  setUp(() {
    sender = Mediator();
    logInCommand = LogInCommand(name: '', password: '');
    logInHandler = MockLogInCommandHandler();
    emptyNameAction = MockEmptyNameAction();
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
          when(() => emptyNameAction.execute(any(), any()))
              .thenAnswer((_) => events.add(emptyNameEvent));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestExceptionActionProcessorBehavior([emptyNameAction]),
            );

          try {
            await logInCommand.sendTo(sender);
          } catch (_) {}

          expect(events, [emptyNameEvent]);
        },
      );
    },
  );
}
