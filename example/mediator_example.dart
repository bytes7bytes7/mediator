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
  LoginCommand({
    required this.name,
    required this.password,
  }) : super(LoginCommand);

  final String name;
  final String password;
}

class LoginCommandHandler extends RequestHandler<AuthResult, LoginCommand> {
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
    extends PipelineBehavior<AuthResult, LoginCommand> {
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
    extends PipelineBehavior<AuthResult, LoginCommand> {
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

class Connecting extends RequestPreProcessor<AuthResult, LoginCommand> {
  const Connecting();

  @override
  FutureOr<void> process(LoginCommand request) {
    print('Connecting to server');
  }
}

class PackingData extends RequestPreProcessor<AuthResult, LoginCommand> {
  const PackingData();

  @override
  FutureOr<void> process(LoginCommand request) {
    print('Packing data');
  }
}

Future<void> main() async {
  final mediator = Mediator()
    ..registerRequestHandler(
      LoginCommandHandler.new,
    )
    ..registerPipelineBehavior(
      LoginNameValidationBehavior.new,
    )
    ..registerPipelineBehavior(
      LoginPasswordValidationBehavior.new,
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
    final authResult = await LoginCommand(
      name: cred.key,
      password: cred.value,
    ).sendTo(mediator);

    print('isLoggedIn: ${authResult.isLoggedIn}');
    print('error: ${authResult.error}');
    print('======');
  }

  for (final cred in credentials) {
    print(
      await LoginCommand(
        name: cred.key,
        password: cred.value,
      ).sendTo(mediator),
    );
  }
}
