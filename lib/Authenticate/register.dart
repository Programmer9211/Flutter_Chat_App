import 'dart:async';

import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  AnimationController boxAnimationController, textAnimationController;
  Animation textAnimation, boxAnimation;
  bool isresize, isLogin, isbuttonAnimating;
  double width = 0;
  double containerHeight, containerWidth;

  @override
  void initState() {
    super.initState();

    isLogin = true;
    isresize = false;
    isbuttonAnimating = false;

    boxAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    textAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    textAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(textAnimationController);
    boxAnimation = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero)
        .animate(boxAnimationController);

    boxAnimationController.forward();

    Timer(Duration(milliseconds: 600), () {
      textAnimationController.forward();
      if (isresize == false) {
        setState(() {
          width = MediaQuery.of(context).size.width / 1.4;
          if (isLogin) {
            containerHeight = MediaQuery.of(context).size.height / 18;
            containerWidth = MediaQuery.of(context).size.width / 5;
          } else {
            containerHeight = MediaQuery.of(context).size.height / 18;
            containerWidth = MediaQuery.of(context).size.width / 4.5;
          }
        });
      }
    });
  }

  void onChange(Size size) {
    if (isLogin) {
      setState(() {
        isLogin = false;
        containerHeight = size.height / 18;
        containerWidth = size.width / 3;
      });
    } else {
      setState(() {
        isLogin = true;
        containerHeight = size.height / 18;
        containerWidth = size.width / 5;
      });
    }
  }

  void onSubmit(Size size) {
    FocusScope.of(context).unfocus();
    setState(() {
      isbuttonAnimating = true;
      containerHeight = size.height / 18;
      containerHeight = size.height / 18;
    });
    Timer(Duration(milliseconds: 300), () {
      setState(() {
        isresize = true;
        width = 1;
      });
    });
    Timer(Duration(milliseconds: 400), () {
      boxAnimationController.reverse();
      textAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Color.fromRGBO(222, 139, 88, 1),
        child: SingleChildScrollView(
            child: AnimatedBuilder(
                animation: boxAnimation,
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
                        height: size.height / 1.9,
                        width: size.width / 1.2,
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height / 30,
                            ),
                            AnimatedBuilder(
                                animation: textAnimation,
                                child: Text(
                                  isLogin ? "Log In" : "Create Account",
                                  style: TextStyle(
                                    fontSize: size.width / 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(222, 139, 88, 1),
                                  ),
                                ),
                                builder: (context, child) {
                                  return ScaleTransition(
                                    scale: textAnimation,
                                    child: child,
                                  );
                                }),
                            SizedBox(
                              height: size.height / 30,
                            ),
                            AnimatedContainer(
                              height: isLogin ? 0 : size.height / 15,
                              width: isLogin ? 0 : width,
                              duration: Duration(milliseconds: 300),
                              child: width == 0
                                  ? Container()
                                  : TextField(
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey,
                                          filled: true,
                                          hintText: "name",
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    ),
                            ),
                            SizedBox(
                              height: size.height / 30,
                            ),
                            AnimatedContainer(
                              height: size.height / 15,
                              width: width,
                              duration: Duration(milliseconds: 300),
                              child: width == 0
                                  ? Container()
                                  : TextField(
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey,
                                          filled: true,
                                          hintText: "Email",
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    ),
                            ),
                            SizedBox(
                              height: size.height / 40,
                            ),
                            AnimatedContainer(
                              height: size.height / 15,
                              width: width,
                              duration: Duration(milliseconds: 300),
                              child: width == 0
                                  ? Container()
                                  : TextField(
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey,
                                          filled: true,
                                          hintText: "Password",
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    ),
                            ),
                            SizedBox(
                              height: size.height / 35,
                            ),
                            isresize
                                ? CircularProgressIndicator()
                                : AnimatedBuilder(
                                    animation: textAnimation,
                                    child: AnimatedContainer(
                                      height: containerHeight == null
                                          ? size.height / 18
                                          : containerHeight,
                                      width: isLogin
                                          ? (containerWidth == null
                                              ? size.height / 5
                                              : containerWidth)
                                          : size.width / 3,
                                      duration: Duration(milliseconds: 300),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(222, 139, 88, 1),
                                        borderRadius: BorderRadius.circular(
                                            isbuttonAnimating ? 1000 : 15),
                                      ),
                                      child: isbuttonAnimating
                                          ? null
                                          : ElevatedButton(
                                              onPressed: () => onSubmit(size),
                                              child: Text(
                                                isLogin
                                                    ? "Login"
                                                    : "Create Account",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color.fromRGBO(
                                                      222, 139, 88, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  )),
                                            ),
                                    ),
                                    builder: (context, child) {
                                      return ScaleTransition(
                                        scale: textAnimation,
                                        child: child,
                                      );
                                    }),
                            SizedBox(
                              height: size.height / 30,
                            ),
                            AnimatedBuilder(
                                animation: textAnimation,
                                child: GestureDetector(
                                  onTap: () => onChange(size),
                                  child: RichText(
                                    text: TextSpan(
                                        text: "New User? ",
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
                                  ),
                                ),
                                builder: (context, child) {
                                  return ScaleTransition(
                                    scale: textAnimation,
                                    child: child,
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                builder: (context, child) {
                  return SlideTransition(
                    position: boxAnimation,
                    child: child,
                  );
                })),
      ),
    );
  }
}
