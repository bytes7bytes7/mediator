import 'dart:async';

import 'package:mediator/mediator.dart';

class AuthResult {
  const AuthResult(this.isLoggedIn);

  final bool isLoggedIn;
}

class LoginCommand extends Request<AuthResult> {
  const LoginCommand({
    required this.login,
    required this.password,
  });

  final String login;
  final String password;
}

class LoginCommandHandler extends RequestHandler<LoginCommand, AuthResult> {
  const LoginCommandHandler();

  @override
  FutureOr<AuthResult> handle(LoginCommand request) {
    if (request.login == 'admin' && request.password == 'admin') {
      return const AuthResult(true);
    }

    return const AuthResult(false);
  }
}

Future<void> main() async {
  final mediator = Mediator()
    ..registerRequestHandler<AuthResult>(() => const LoginCommandHandler());

  final authResult1 = await mediator.send(
    const LoginCommand(
      login: 'admin',
      password: 'admin',
    ),
  );

  print('Authentication ${authResult1.isLoggedIn ? 'succeeded' : 'failed'}');

  final authResult2 = await mediator.send(
    const LoginCommand(
      login: 'login',
      password: 'password',
    ),
  );

  print('Authentication ${authResult2.isLoggedIn ? 'succeeded' : 'failed'}');
}
