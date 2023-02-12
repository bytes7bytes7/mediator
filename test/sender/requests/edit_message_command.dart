import 'package:mediator/mediator.dart';

import '../models/models.dart';

class EditMessageCommand extends StreamRequest<Message> {
  EditMessageCommand() : super(EditMessageCommand);
}
