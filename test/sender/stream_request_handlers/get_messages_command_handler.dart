import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';

import '../models/message.dart';
import '../requests/get_messages_command.dart';

class MockGetMessagesCommandHandler extends Mock
    implements StreamRequestHandler<GetMessagesCommand, Message> {}
