import 'dart:async';

class ChatBloc {
  StreamController<Map<String, dynamic>> controller =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => controller.stream;
}
