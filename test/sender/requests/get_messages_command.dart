import 'package:mediator/mediator.dart';

import '../models/message.dart';

class GetMessagesCommand extends StreamRequest<Message> {
  GetMessagesCommand() : super(GetMessagesCommand);
}
