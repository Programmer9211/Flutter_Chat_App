import 'package:chatapp/Authenticate/Authenticate.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp(prefs));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  MyApp(this.prefs);

  final Map<int, Color> color = {
    50: Color.fromRGBO(41, 60, 98, .1),
    100: Color.fromRGBO(41, 60, 98, .2),
    200: Color.fromRGBO(41, 60, 98, .3),
    300: Color.fromRGBO(41, 60, 98, .4),
    400: Color.fromRGBO(41, 60, 98, .5),
    500: Color.fromRGBO(41, 60, 98, .6),
    600: Color.fromRGBO(41, 60, 98, .7),
    700: Color.fromRGBO(41, 60, 98, .8),
    800: Color.fromRGBO(41, 60, 98, .9),
    900: Color.fromRGBO(41, 60, 98, 1),
  };

  MaterialColor custom;

  @override
  Widget build(BuildContext context) {
    custom = MaterialColor(0xFF999999, color);
    return MaterialApp(
      title: 'Chat App!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: custom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Authenticate(prefs),
    );
  }
}
