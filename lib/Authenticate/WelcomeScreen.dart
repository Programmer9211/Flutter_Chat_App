import 'package:chatapp/Authenticate/Login.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final prefs;
  WelcomeScreen(this.prefs);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 236, 250, 1),
      body: Column(
        children: [
          SizedBox(
            height: size.height / 10,
          ),
          Container(
            height: size.height / 3,
            width: size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://image.shutterstock.com/image-vector/vector-illustration-flat-linear-style-260nw-1147927685.jpg'),
                  fit: BoxFit.cover),
            ),
          ),
          SizedBox(
            height: size.height / 20,
          ),
          Text(
            "Welcome To Chat App!",
            style: TextStyle(
                fontSize: size.width / 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: size.height / 20,
          ),
          Text(
            "Chat App a new way to connect ",
            style: TextStyle(
              fontSize: size.width / 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "with people.",
            style: TextStyle(
              fontSize: size.width / 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: size.height / 10,
          ),
          customButton(
              size,
              Color.fromRGBO(129, 110, 217, 1),
              "Create Account",
              () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => LoginScreen(
                        prefs: prefs,
                        isLogin: false,
                      )))),
          customButton(
              size,
              Color.fromRGBO(244, 136, 36, 1),
              "Log In",
              () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => LoginScreen(
                        prefs: prefs,
                        isLogin: true,
                      )))),
        ],
      ),
    );
  }

  Widget customButton(Size size, Color color, String text, Function onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          color: color,
          elevation: 8,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: size.height / 12.9,
            width: size.width / 1.2,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width / 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
