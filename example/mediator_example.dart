// ignore_for_file: avoid_print

import 'dart:async';

import 'package:mediator/mediator.dart';

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
  LogInCommand({
    required this.name,
    required this.password,
  }) : super(LogInCommand);

  final String name;
  final String password;
}

class LogInCommandHandler extends RequestHandler<AuthResult, LogInCommand> {
  const LogInCommandHandler();

  @override
  FutureOr<AuthResult> handle(LogInCommand request) {
    if (request.name == 'admin' && request.password == 'admin') {
      return const AuthResult(true);
    }

    return const AuthResult(false);
  }
}

class LogInNameValidationBehavior
    extends PipelineBehavior<AuthResult, LogInCommand> {
  const LogInNameValidationBehavior();

  @override
  FutureOr<AuthResult> handle(
    LogInCommand request,
    RequestHandlerDelegate<AuthResult> next,
  ) {
    if (request.name.isEmpty) {
      return const AuthResult(
        false,
        error: 'Name cannot be empty',
      );
    }

    return next();
  }
}

class LogInPasswordValidationBehavior
    extends PipelineBehavior<AuthResult, LogInCommand> {
  const LogInPasswordValidationBehavior();

  @override
  FutureOr<AuthResult> handle(
    LogInCommand request,
    RequestHandlerDelegate<AuthResult> next,
  ) {
    if (request.password.isEmpty) {
      return AuthResult(
        false,
        error: 'Password cannot be empty',
      );
    }

    return next();
  }
}

class Connecting extends RequestPreProcessor<AuthResult, LogInCommand> {
  const Connecting();

  @override
  FutureOr<void> process(LogInCommand request) {
    print('Connecting to server');
  }
}

class PackingData extends RequestPreProcessor<AuthResult, LogInCommand> {
  const PackingData();

  @override
  FutureOr<void> process(LogInCommand request) {
    print('Packing data');
  }
}

Future<void> main() async {
  final mediator = Mediator()
    ..registerRequestHandler(
      LogInCommandHandler.new,
    )
    ..registerPipelineBehavior(
      LogInNameValidationBehavior.new,
    )
    ..registerPipelineBehavior(
      LogInPasswordValidationBehavior.new,
    )
    ..registerPipelineBehavior(
      () => RequestPreProcessorBehavior(
        [
          Connecting(),
          PackingData(),
        ],
      ),
    );

  final credentials = [
    MapEntry(
      'admin',
      'admin',
    ),
    MapEntry(
      'admin',
      '1',
    ),
    MapEntry(
      '',
      'admin',
    ),
    MapEntry(
      'admin',
      '',
    ),
    MapEntry(
      '',
      '',
    ),
  ];

  for (final cred in credentials) {
    final authResult = await LogInCommand(
      name: cred.key,
      password: cred.value,
    ).sendTo(mediator);

    print('isLoggedIn: ${authResult.isLoggedIn}');
    print('error: ${authResult.error}');
    print('======');
  }

  for (final cred in credentials) {
    print(
      await LogInCommand(
        name: cred.key,
        password: cred.value,
      ).sendTo(mediator),
    );
  }
}
