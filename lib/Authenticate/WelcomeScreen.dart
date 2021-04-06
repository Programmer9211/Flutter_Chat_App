import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.height / 10,
          ),
          Container(
            height: size.height / 3,
            width: size.width / 1.01,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
            "with people",
            style: TextStyle(
                fontSize: size.width / 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: size.height / 10,
          ),
          customButton(size, () {}, Colors.blue, "Create Account"),
          customButton(size, () {}, Colors.blue, "Log In"),
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
