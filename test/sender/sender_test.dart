import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'handlers/handlers.dart';
import 'models/models.dart';
import 'processors/check_connection_pre_processor.dart';
import 'processors/loading_pre_processor.dart';
import 'processors/packing_data_pre_processor.dart';
import 'requests/requests.dart';

void main() {
  late Sender sender;
  late AuthResult authResult;
  late Message message;
  late LogInCommand logInCommand;
  late GetMessagesCommand getMessagesCommand;
  late RequestHandler<AuthResult, LogInCommand> logInHandler;
  late RequestHandler<AuthResult, LogOutCommand> logOutHandler;
  late StreamRequestHandler<Message, GetMessagesCommand> getMessagesHandler;
  late StreamRequestHandler<Message, EditMessageCommand> editMessageHandler;
  late RequestPreProcessor<AuthResult, LogInCommand> loadingPreProcessor;
  late RequestPreProcessor<AuthResult, LogInCommand> packingDataPreProcessor;
  late RequestPreProcessor<AuthResult, LogOutCommand>
      checkConnectionPreProcessor;

  setUpAll(() {
    registerFallbackValue(LogInCommand(name: '', password: ''));
    registerFallbackValue(Message('text'));
    registerFallbackValue(GetMessagesCommand());
    registerFallbackValue(EditMessageCommand());
  });

  setUp(() {
    sender = Mediator();
    authResult = AuthResult(false);
    message = Message('text');
    logInCommand = LogInCommand(name: 'name', password: 'password');
    getMessagesCommand = GetMessagesCommand();
    logInHandler = MockLogInCommandHandler();
    logOutHandler = MockLogOutCommandHandler();
    getMessagesHandler = MockGetMessagesCommandHandler();
    editMessageHandler = MockEditMessageCommandHandler();
    loadingPreProcessor = MockLoadingPreProcessor();
    packingDataPreProcessor = MockPackingDataPreProcessor();
    checkConnectionPreProcessor = MockCheckConnectionPreProcessor();
  });

  group(
    'Sender',
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
        'throws when no $StreamRequestHandler is registered',
        () async {
          await expectLater(
            () => getMessagesCommand.createStream(sender),
            throwsA(
              TypeMatcher<StreamRequestHandlerNotRegistered>(),
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
        'throws when a proper $StreamRequestHandler is not registered',
        () async {
          await expectLater(
            () => getMessagesCommand.createStream(sender),
            throwsA(
              TypeMatcher<StreamRequestHandlerNotRegistered>(),
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
        'does not throw when a proper $StreamRequestHandler is registered',
        () async {
          when(() => getMessagesHandler.handle(any()))
              .thenAnswer((_) => Stream.value(message));

          sender.registerStreamRequestHandler(
            () => getMessagesHandler,
          );

          await expectLater(
            getMessagesCommand.createStream(sender).first,
            completion(message),
          );
        },
      );

      test(
        'first $RequestHandler works well when multiple ${RequestHandler}s '
        'are registered',
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
        'last $RequestHandler works well when multiple ${RequestHandler}s '
        'are registered',
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

      test(
        'first $StreamRequestHandler works well when multiple '
        '${StreamRequestHandler}s are registered',
        () async {
          when(() => getMessagesHandler.handle(any()))
              .thenAnswer((_) => Stream.value(message));

          sender
            ..registerStreamRequestHandler(
              () => getMessagesHandler,
            )
            ..registerStreamRequestHandler(
              () => editMessageHandler,
            );

          await expectLater(
            getMessagesCommand.createStream(sender).first,
            completion(message),
          );
        },
      );

      test(
        'last $StreamRequestHandler works well when multiple '
        '${StreamRequestHandler}s are registered',
        () async {
          when(() => getMessagesHandler.handle(any()))
              .thenAnswer((_) => Stream.value(message));

          sender
            ..registerStreamRequestHandler(
              () => editMessageHandler,
            )
            ..registerStreamRequestHandler(
              () => getMessagesHandler,
            );

          await expectLater(
            getMessagesCommand.createStream(sender).first,
            completion(message),
          );
        },
      );

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
        'single $RequestPreProcessorBehavior with multiple '
        '${RequestPreProcessor}s works',
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
        'multiple ${RequestPreProcessorBehavior}s that belong to the '
        'same $Request work in proper order',
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
        'first $RequestPreProcessorBehavior works when multiple '
        '${RequestPreProcessorBehavior}s are registered',
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
        'last $RequestPreProcessorBehavior works when multiple '
        '${RequestPreProcessorBehavior}s are registered',
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
