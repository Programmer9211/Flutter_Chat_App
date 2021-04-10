import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Color.fromRGBO(222, 139, 88, 1),
        child: Column(
          children: [
            SizedBox(
              height: size.height / 12,
            ),
            Text(
              "Chat App!",
              style: TextStyle(
                fontSize: size.width / 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: size.height / 10,
            ),
            Material(
              elevation: 25,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.white,
              child: Container(
                height: size.height / 2.2,
                width: size.width / 1.2,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height / 30,
                    ),
                    Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: size.width / 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(222, 139, 88, 1),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 30,
                    ),
                    Container(
                      height: size.height / 15,
                      width: size.width / 1.4,
                      child: TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.grey,
                            filled: true,
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    Container(
                      height: size.height / 15,
                      width: size.width / 1.4,
                      child: TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.grey,
                            filled: true,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 35,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(222, 139, 88, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                    SizedBox(
                      height: size.height / 30,
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Dont't have account?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: "Create Account",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ))
                          ]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
