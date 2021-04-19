import 'package:chatapp/Authenticate/WelcomeScreen.dart';
import 'package:chatapp/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authenticate extends StatefulWidget {
  final SharedPreferences prefs;
  Authenticate(this.prefs);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  String username;

  @override
  void initState() {
    super.initState();

    username = widget.prefs.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    return username != null
        ? HomeScreen(
            prefs: widget.prefs,
          )
        : WelcomeScreen(widget.prefs);
  }
}
