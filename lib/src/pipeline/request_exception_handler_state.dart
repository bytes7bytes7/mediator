class RequestExceptionHandlerState<RS> {
  const RequestExceptionHandlerState({
    this.isHandled = false,
    this.response,
  });

  final bool isHandled;
  final RS? response;
}
