import 'dart:async';

class ChatBloc {
  StreamController<Map<String, dynamic>> controller =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => controller.stream;

  StreamController<String> statusController =
      StreamController<String>.broadcast();

  Stream<String> get statusStream => statusController.stream;

  StreamController<String> idController = StreamController<String>.broadcast();

  Stream<String> get idStream => idController.stream;
}
