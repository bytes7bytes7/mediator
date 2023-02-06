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

class LoginCommand extends Request<AuthResult> {
  const LoginCommand({
    required this.name,
    required this.password,
  });

  final String name;
  final String password;
}

class LoginCommandHandler extends RequestHandler<LoginCommand, AuthResult> {
  const LoginCommandHandler();

  @override
  FutureOr<AuthResult> handle(LoginCommand request) {
    if (request.name == 'admin' && request.password == 'admin') {
      return const AuthResult(true);
    }

    return const AuthResult(false);
  }
}

class LoginNameValidationBehavior
    extends PipelineBehavior<LoginCommand, AuthResult> {
  const LoginNameValidationBehavior();

  @override
  FutureOr<AuthResult> handle(
    LoginCommand request,
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

class LoginPasswordValidationBehavior
    extends PipelineBehavior<LoginCommand, AuthResult> {
  const LoginPasswordValidationBehavior();

  @override
  FutureOr<AuthResult> handle(
    LoginCommand request,
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

class Connecting extends RequestPreProcessor<LoginCommand> {
  const Connecting();

  @override
  FutureOr<void> process(LoginCommand request) {
    print('Connecting to server');
  }
}

class PackingData extends RequestPreProcessor<LoginCommand> {
  const PackingData();

  @override
  FutureOr<void> process(LoginCommand request) {
    print('Packing data');
  }
}

Future<void> main() async {
  final mediator = Mediator()
    ..registerRequestHandler<AuthResult>(() => const LoginCommandHandler())
    ..registerPipelineBehavior(() => const LoginNameValidationBehavior())
    ..registerPipelineBehavior(() => const LoginPasswordValidationBehavior())
    ..registerPipelineBehavior(
      () => const RequestPreProcessorBehavior<LoginCommand, AuthResult>(
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
  ];

  for (final cred in credentials) {
    final authResult = await mediator.send(
      LoginCommand(
        name: cred.key,
        password: cred.value,
      ),
    );

    print(authResult);
  }
}
