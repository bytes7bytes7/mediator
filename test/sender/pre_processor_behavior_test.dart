import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'models/models.dart';
import 'pre_processors/pre_processors.dart';
import 'request_handlers/request_handlers.dart';
import 'requests/requests.dart';

void main() {
  late Sender sender;
  late AuthResult authResult;
  late LogInCommand logInCommand;
  late RequestHandler<LogInCommand, AuthResult> logInHandler;
  late RequestPreProcessor<LogInCommand, AuthResult> loadingPreProcessor;
  late RequestPreProcessor<LogInCommand, AuthResult> packingDataPreProcessor;
  late RequestPreProcessor<LogOutCommand, AuthResult>
      checkConnectionPreProcessor;

  setUpAll(() {
    registerFallbackValue(LogInCommand(name: '', password: ''));
  });

  setUp(() {
    sender = Mediator();
    authResult = AuthResult(false);
    logInCommand = LogInCommand(name: 'name', password: 'password');
    logInHandler = MockLogInCommandHandler();
    loadingPreProcessor = MockLoadingPreProcessor();
    packingDataPreProcessor = MockPackingDataPreProcessor();
    checkConnectionPreProcessor = MockCheckConnectionPreProcessor();
  });

  group(
    '$RequestPreProcessorBehavior',
    () {
      test(
        'single $RequestPreProcessorBehavior with 1 $RequestPreProcessor works',
        () async {
          final events = <String>[];
          final loadingEvent = 'loading';

          when(() => logInHandler.handle(any())).thenReturn(authResult);
          when(() => loadingPreProcessor.process(any()))
              .thenAnswer((_) => events.add(loadingEvent));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestPreProcessorBehavior([loadingPreProcessor]),
            );

          await logInCommand.sendTo(sender);

          expect(events, [loadingEvent]);
        },
      );

      test(
        'single $RequestPreProcessorBehavior with multiple'
        ' ${RequestPreProcessor}s works',
        () async {
          final events = <String>[];
          final loadingEvent = 'loading';
          final packingDataEvent = 'packing data';

          when(() => logInHandler.handle(any())).thenReturn(authResult);
          when(() => loadingPreProcessor.process(any()))
              .thenAnswer((_) => events.add(loadingEvent));
          when(() => packingDataPreProcessor.process(any()))
              .thenAnswer((_) => events.add(packingDataEvent));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestPreProcessorBehavior([
                loadingPreProcessor,
                packingDataPreProcessor,
              ]),
            );

          await logInCommand.sendTo(sender);

          expect(
            events,
            [
              loadingEvent,
              packingDataEvent,
            ],
          );
        },
      );

      test(
        'multiple ${RequestPreProcessorBehavior}s that belong to the'
        ' same $Request work in an order direct to a registration order',
        () async {
          final events = <String>[];
          final loadingEvent = 'loading';
          final packingDataEvent = 'packing data';

          when(() => logInHandler.handle(any())).thenReturn(authResult);
          when(() => loadingPreProcessor.process(any()))
              .thenAnswer((_) => events.add(loadingEvent));
          when(() => packingDataPreProcessor.process(any()))
              .thenAnswer((_) => events.add(packingDataEvent));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestPreProcessorBehavior([loadingPreProcessor]),
            )
            ..registerPipelineBehavior(
              () => RequestPreProcessorBehavior([packingDataPreProcessor]),
            );

          await logInCommand.sendTo(sender);

          expect(
            events,
            [
              loadingEvent,
              packingDataEvent,
            ],
          );
        },
      );

      test(
        'first $RequestPreProcessorBehavior works when multiple'
        ' ${RequestPreProcessorBehavior}s are registered',
        () async {
          final events = <String>[];
          final loadingEvent = 'loading';

          when(() => logInHandler.handle(any())).thenReturn(authResult);
          when(() => loadingPreProcessor.process(any()))
              .thenAnswer((_) => events.add(loadingEvent));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestPreProcessorBehavior([loadingPreProcessor]),
            )
            ..registerPipelineBehavior(
              () => RequestPreProcessorBehavior([checkConnectionPreProcessor]),
            );

          await logInCommand.sendTo(sender);

          expect(events, [loadingEvent]);
        },
      );

      test(
        'last $RequestPreProcessorBehavior works when multiple'
        ' ${RequestPreProcessorBehavior}s are registered',
        () async {
          final events = <String>[];
          final loadingEvent = 'loading';

          when(() => logInHandler.handle(any())).thenReturn(authResult);
          when(() => loadingPreProcessor.process(any()))
              .thenAnswer((_) => events.add(loadingEvent));

          sender
            ..registerRequestHandler(() => logInHandler)
            ..registerPipelineBehavior(
              () => RequestPreProcessorBehavior([checkConnectionPreProcessor]),
            )
            ..registerPipelineBehavior(
              () => RequestPreProcessorBehavior([loadingPreProcessor]),
            );

          await logInCommand.sendTo(sender);

          expect(events, [loadingEvent]);
        },
      );
    },
  );
}
