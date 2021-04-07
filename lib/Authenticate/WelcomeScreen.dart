import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
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
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://image.shutterstock.com/image-vector/vector-illustration-flat-linear-style-260nw-1147927685.jpg'),
                    fit: BoxFit.cover)),
          ),
          SizedBox(
            height: size.height / 20,
          ),
          Text(
            "Welcome to Chat App!",
            style: TextStyle(
                fontSize: size.width / 13, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: size.height / 20,
          ),
          Text(
            "Chat App a new way to connect ",
            style: TextStyle(
                fontSize: size.width / 20, fontWeight: FontWeight.w500),
          ),
          Text(
            "with people.",
            style: TextStyle(
                fontSize: size.width / 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: size.height / 10,
          ),
          customButton(
              size, () {}, Color.fromRGBO(129, 110, 217, 1), "Create Account"),
          customButton(size, () {}, Color.fromRGBO(244, 136, 36, 1), "Log In"),
        ],
      ),
    );
  }

  Widget customButton(Size size, Function func, Color color, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(8),
        child: GestureDetector(
          onTap: func,
          child: Container(
            height: size.height / 12.9,
            width: size.width / 1.2,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: color),
            child: Text(
              title,
              style: TextStyle(
                fontSize: size.width / 22,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
