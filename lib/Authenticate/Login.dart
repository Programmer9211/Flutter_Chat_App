import 'dart:async';
import 'package:chatapp/Authenticate/OtpAuthentication.dart';
import 'package:chatapp/Screens/HomeScreen.dart';
import 'package:chatapp/Services/Network.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final bool isLogin;
  LoginScreen({this.isLogin, this.prefs});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  SharedPreferences prefs;
  AnimationController controller, textAnim;
  Animation animation, textAnimation;
  bool isresize, buttonAnim, isLogin;
  double width = 0;
  double contH, contW;
  TextEditingController _name = TextEditingController();
  TextEditingController _gmail = TextEditingController();
  TextEditingController _password = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin notificationsPlugin;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    isresize = false;
    buttonAnim = false;
    isLogin = widget.isLogin;
    prefs = widget.prefs;
    permission();
    initMessaging();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    textAnim =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    animation = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero)
        .animate(controller);
    textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(textAnim);

    controller.forward();

    Timer(
      Duration(milliseconds: 600),
      () {
        textAnim.forward();
        if (isresize == false) {
          setState(() {
            width = MediaQuery.of(context).size.width / 1.4;
            if (isLogin) {
              contH = MediaQuery.of(context).size.height / 18;
              contW = MediaQuery.of(context).size.width / 5;
            } else {
              contH = MediaQuery.of(context).size.height / 18;
              contW = MediaQuery.of(context).size.width / 4.5;
            }
          });
        }
      },
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid email address';
    else
      return null;
  }

  void onPressed(Size size) {
    if (validateEmail(_gmail.text) == "Enter a valid email address") {
      _gmail.text = "${_gmail.text}@gmail.com";
      setState(() {});
      _key.currentState.validate();
    } else if (_password.text.length < 8) {
      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text("Password must be atleast 8 character long")));
    } else {
      FocusScope.of(context).unfocus();
      setState(() {
        buttonAnim = true;
        contH = size.height / 18;
        contW = size.height / 18;
      });

      Timer(Duration(milliseconds: 300), () {
        isresize = true;
        setState(() {});
      });

      if (isLogin) {
        Map<String, dynamic> maps = {
          "gmail": _gmail.text,
          "password": _password.text,
        };

        print(maps);
        loginUser(maps).then((map) {
          Timer(Duration(milliseconds: 300), () {
            if (map['msg'] == "Login Sucessful") {
              setState(() {
                width = 1;
              });
              textAnim.reverse();
            } else {
              isresize = false;
              buttonAnim = false;
              contH = null;
              contW = null;
              setState(() {});
            }

            Timer(Duration(milliseconds: 401), () async {
              if (map['msg'] == "Login Sucessful") {
                await prefs
                    .setString('username', map['data']['username'])
                    .then((value) => print(value));
                await prefs.setString('gmail', map['data']['gmail']);
                await prefs.setString('image', map['data']['image']);
                controller.reverse();
                width = 0;
                setState(() {});

                String gmail = map['data']['gmail'];

                String topic = gmail.substring(0, gmail.length - 10);

                print(topic);

                await messaging.subscribeToTopic(topic);

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              prefs: prefs,
                            )),
                    (Route<dynamic> route) => false);
              } else if (map['msg'] == "User doesn't Exist") {
                // ignore: deprecated_member_use
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text("User doesn't Exist")));
              } else if (map['msg'] == "Password is Incorrect") {
                // ignore: deprecated_member_use
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text("Password is Incorrect")));
              } else {
                // ignore: deprecated_member_use
                _scaffoldKey.currentState.showSnackBar(
                    SnackBar(content: Text("An Unexpected error occured")));
              }
              print(map['msg']);
            });
          });
        });
      } else {
        if (_name.text.length == 0) {
          // ignore: deprecated_member_use
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("Please Enter a valid name")));
        } else if (_name.text.length > 10) {
          // ignore: deprecated_member_use
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("Name should not exceed 10 characters")));
        } else {
          sendOtp().then((value) {
            Timer(Duration(milliseconds: 300), () {
              if (value) {
                setState(() {
                  width = 1;
                });
                textAnim.reverse();
              }

              Timer(Duration(milliseconds: 401), () async {
                if (value) {
                  width = 0;
                  setState(() {});
                  controller.reverse();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => OtpAuthentication(
                              gmail: _gmail.text,
                              name: _name.text,
                              prefs: prefs,
                              password: _password.text,
                              messaging: messaging,
                            )),
                  );
                }
              });
            });
          });
        }
      }
    }
  }

  Future<bool> sendOtp() async {
    EmailAuth.sessionName = "Chat App!";
    bool result = await EmailAuth.sendOtp(receiverMail: _gmail.text);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
          height: size.height,
          width: size.width,
          color: Color.fromRGBO(222, 139, 88, 1),
          child: SingleChildScrollView(
              child: AnimatedBuilder(
            animation: animation,
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
                      //color: Color.fromRGBO(41, 60, 98, 1),
                      color: Colors.white),
                ),
                SizedBox(
                  height: size.height / 7,
                ),
                Material(
                  elevation: 25,
                  shape: RoundedRectangleBorder(
                    // side: BorderSide(
                    //   width: 2,
                    //   color: Color.fromRGBO(41, 60, 98, 1),
                    // ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // color: Color.fromRGBO(81, 223, 232, 1),
                  child: Container(
                    height: size.height / 1.9,
                    width: size.width / 1.2,
                    decoration: BoxDecoration(),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height / 30,
                        ),
                        AnimatedBuilder(
                            animation: textAnimation,
                            child: Text(
                              isLogin ? 'Log In' : "Create Account",
                              style: TextStyle(
                                fontSize: size.width / 18,
                                fontWeight: FontWeight.w500,
                                //color: Color.fromRGBO(41, 60, 98, 1),
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
                          alignment: Alignment.centerLeft,
                          duration: Duration(milliseconds: 400),
                          child: width == 0
                              ? Container()
                              : TextField(
                                  controller: _name,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey,
                                    filled: true,
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    hintText: "name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(height: size.height / 40),
                        AnimatedContainer(
                          height: _gmail.text.isEmpty
                              ? size.height / 15
                              : (validateEmail(_gmail.text) != null
                                  ? size.height / 10.5
                                  : size.height / 15),
                          width: width,
                          duration: Duration(milliseconds: 400),
                          child: width == 0
                              ? Container()
                              : Form(
                                  key: _key,
                                  //autovalidateMode: AutovalidateMode.always,
                                  child: TextFormField(
                                    validator: validateEmail,
                                    controller: _gmail,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      isDense: true,

                                      fillColor: Colors.grey,
                                      filled: true,
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                      hintText: "gmail",
                                      //helperText: " ",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(height: size.height / 40),
                        AnimatedContainer(
                          height: size.height / 15,
                          width: width,
                          duration: Duration(milliseconds: 400),
                          child: width == 0
                              ? Container()
                              : TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: _password,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey,
                                    filled: true,
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    hintText: "password",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: size.height / 40,
                        ),
                        isresize
                            ? CircularProgressIndicator()
                            : AnimatedBuilder(
                                animation: textAnimation,
                                child: AnimatedContainer(
                                  height:
                                      contH == null ? size.height / 18 : contH,
                                  width: isLogin
                                      ? (contW == null ? size.width / 5 : contW)
                                      : size.width / 3,
                                  duration: Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(222, 139, 88, 1),
                                      borderRadius: BorderRadius.circular(
                                          buttonAnim ? 1000 : 15)),
                                  child: buttonAnim
                                      ? null
                                      : ElevatedButton(
                                          onPressed: () => onPressed(size),
                                          child: Text(
                                              isLogin
                                                  ? "Login"
                                                  : "Create Account",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: size.width / 30)),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            primary:
                                                Color.fromRGBO(222, 139, 88, 1),
                                            // primary:
                                            //     Color.fromRGBO(41, 60, 98, 1),
                                          ),
                                        ),
                                ),
                                builder: (context, child) {
                                  return ScaleTransition(
                                    scale: textAnimation,
                                    child: child,
                                  );
                                },
                              ),
                        SizedBox(
                          height: size.height / 40,
                        ),
                        AnimatedBuilder(
                            animation: textAnim,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "New User ",
                                  style: TextStyle(
                                    fontSize: size.width / 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (isLogin) {
                                      setState(() {
                                        // _gmail.text = "@gmail.com";
                                        isLogin = !isLogin;
                                        contH = size.height / 18;
                                        contW = size.width / 3;
                                      });
                                    } else {
                                      setState(() {
                                        // _gmail.text = "@gmail.com";
                                        isLogin = !isLogin;
                                        contH = size.height / 18;
                                        contW = size.width / 5;
                                      });
                                    }
                                    // textAnim.reset();
                                    // textAnim.forward();
                                  },
                                  child: Text(
                                    isLogin ? "Create Account" : "Sign In",
                                    style: TextStyle(
                                      fontSize: size.width / 25,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            builder: (context, child) {
                              return ScaleTransition(
                                scale: textAnim,
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
                position: animation,
                child: child,
              );
            },
          ))),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    textAnim.dispose();
    _name.dispose();
    _gmail.dispose();
    _password.dispose();
    super.dispose();
  }

  void initMessaging() async {
    var androidinit = AndroidInitializationSettings('flut');

    var iosInitialize = IOSInitializationSettings();

    var initSetting =
        InitializationSettings(android: androidinit, iOS: iosInitialize);

    notificationsPlugin = FlutterLocalNotificationsPlugin();

    notificationsPlugin.initialize(initSetting);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      print(notification.title);
      showNotifications(
          notification.title, notification.body, notification.hashCode);
    });
  }

  void showNotifications(String title, String body, int hashCode) async {
    var andDetails = AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription");

    var iosDetails = IOSNotificationDetails();

    var generalNotifiDDetails =
        NotificationDetails(android: andDetails, iOS: iosDetails);

    await notificationsPlugin.show(
      hashCode,
      title,
      body,
      generalNotifiDDetails,
    );
  }

  void permission() async {
    await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
  }
}
