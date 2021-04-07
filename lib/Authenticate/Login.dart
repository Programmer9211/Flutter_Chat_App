import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
          height: size.height,
          width: size.width,
          color: Color.fromRGBO(222, 139, 88, 1),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height / 12,
                ),
                Text(
                  'Chat App!',
                  style: TextStyle(
                    fontSize: size.width / 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: size.height / 7,
                ),
                Material(
                  elevation: 25,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  //color: Color.fromRGBO(81, 223, 232, 1),
                  child: Container(
                    height: size.height / 2.5,
                    width: size.width / 1.2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height / 30,
                        ),
                        Text(
                          'Log In',
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
                              labelText: "email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height / 40),
                        Container(
                          height: size.height / 15,
                          width: size.width / 1.4,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height / 40,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            primary: Color.fromRGBO(222, 139, 88, 1),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
