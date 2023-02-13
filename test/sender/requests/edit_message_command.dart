import 'package:mediator/mediator.dart';

import '../models/message.dart';

class EditMessageCommand extends StreamRequest<Message> {
  EditMessageCommand() : super(EditMessageCommand);
}
