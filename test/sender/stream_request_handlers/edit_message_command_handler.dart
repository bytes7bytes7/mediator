import 'package:mediator/mediator.dart';
import 'package:mocktail/mocktail.dart';

import '../models/message.dart';
import '../requests/edit_message_command.dart';

class MockEditMessageCommandHandler extends Mock
    implements StreamRequestHandler<EditMessageCommand, Message> {}
