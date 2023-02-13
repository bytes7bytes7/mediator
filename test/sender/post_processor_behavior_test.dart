import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'handlers/handlers.dart';
import 'models/models.dart';
import 'post_processors/post_processors.dart';
import 'requests/requests.dart';

void main() {
  late Sender sender;
  late AuthResult authResult;
  late LogInCommand logInCommand;
  late RequestHandler<AuthResult, LogInCommand> logInHandler;
  late RequestPostProcessor<AuthResult, LogInCommand> saveTokenPostProcessor;
  late RequestPostProcessor<AuthResult, LogInCommand> loadUserDataPostProcessor;
  late RequestPostProcessor<AuthResult, LogOutCommand> removeTokenPostProcessor;

  setUpAll(() {
    registerFallbackValue(LogInCommand(name: '', password: ''));
    registerFallbackValue(AuthResult(false, error: ''));
  });

  setUp(() {
    sender = Mediator();
    authResult = AuthResult(false);
    logInCommand = LogInCommand(name: 'name', password: 'password');
    logInHandler = MockLogInCommandHandler();
    saveTokenPostProcessor = MockSaveTokenPostProcessor();
    loadUserDataPostProcessor = MockLoadUserDataPostProcessor();
    removeTokenPostProcessor = MockRemoveTokenPostProcessor();
  });

  group(
    '$RequestPostProcessorBehavior',
    () {
      test(
        'single $RequestPostProcessorBehavior with 1'
        ' $RequestPostProcessor works',
        () async {
          final events = <String>[];
          final saveToken = 'save token';

          when(() => logInHandler.handle(any())).thenReturn(authResult);
          when(() => saveTokenPostProcessor.process(any(), any()))
              .thenAnswer((_) => events.add(saveToken));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestPostProcessorBehavior([saveTokenPostProcessor]),
            );

          await logInCommand.sendTo(sender);

          expect(events, [saveToken]);
        },
      );

      test(
        'single $RequestPostProcessorBehavior with multiple'
        ' ${RequestPostProcessor}s works',
        () async {
          final events = <String>[];
          final saveToken = 'save token';
          final loadUserDataEvent = 'load user data';

          when(() => logInHandler.handle(any())).thenReturn(authResult);
          when(() => saveTokenPostProcessor.process(any(), any()))
              .thenAnswer((_) => events.add(saveToken));
          when(() => loadUserDataPostProcessor.process(any(), any()))
              .thenAnswer((_) => events.add(loadUserDataEvent));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestPostProcessorBehavior([
                saveTokenPostProcessor,
                loadUserDataPostProcessor,
              ]),
            );

          await logInCommand.sendTo(sender);

          expect(
            events,
            [
              saveToken,
              loadUserDataEvent,
            ],
          );
        },
      );

      test(
        'multiple ${RequestPostProcessorBehavior}s that belong to the'
        ' same $Request work in an order reversed to a registration order',
        () async {
          final events = <String>[];
          final saveToken = 'save token';
          final loadUserDataEvent = 'load user data';

          when(() => logInHandler.handle(any())).thenReturn(authResult);
          when(() => saveTokenPostProcessor.process(any(), any()))
              .thenAnswer((_) => events.add(saveToken));
          when(() => loadUserDataPostProcessor.process(any(), any()))
              .thenAnswer((_) => events.add(loadUserDataEvent));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestPostProcessorBehavior([saveTokenPostProcessor]),
            )
            ..registerPipelineBehavior(
              () => RequestPostProcessorBehavior([loadUserDataPostProcessor]),
            );

          await logInCommand.sendTo(sender);

          expect(
            events,
            [
              loadUserDataEvent,
              saveToken,
            ],
          );
        },
      );

      test(
        'first $RequestPostProcessorBehavior works when multiple'
        ' ${RequestPostProcessorBehavior}s are registered',
        () async {
          final events = <String>[];
          final saveToken = 'save token';

          when(() => logInHandler.handle(any())).thenReturn(authResult);
          when(() => saveTokenPostProcessor.process(any(), any()))
              .thenAnswer((_) => events.add(saveToken));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestPostProcessorBehavior([saveTokenPostProcessor]),
            )
            ..registerPipelineBehavior(
              () => RequestPostProcessorBehavior([removeTokenPostProcessor]),
            );

          await logInCommand.sendTo(sender);

          expect(events, [saveToken]);
        },
      );

      test(
        'last $RequestPostProcessorBehavior works when multiple'
        ' ${RequestPostProcessorBehavior}s are registered',
        () async {
          final events = <String>[];
          final saveToken = 'save token';

          when(() => logInHandler.handle(any())).thenReturn(authResult);
          when(() => saveTokenPostProcessor.process(any(), any()))
              .thenAnswer((_) => events.add(saveToken));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestPostProcessorBehavior([removeTokenPostProcessor]),
            )
            ..registerPipelineBehavior(
              () => RequestPostProcessorBehavior([saveTokenPostProcessor]),
            );

          await logInCommand.sendTo(sender);

          expect(events, [saveToken]);
        },
      );
    },
  );
}
