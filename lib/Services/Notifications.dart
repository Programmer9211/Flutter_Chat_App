import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Notification {
  FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future initialize() async {}

  void subscribe(String topic) async {
    await fcm.subscribeToTopic(topic);
  }
}
