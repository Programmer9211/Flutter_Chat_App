import 'package:chatapp/Dialoges/Dialgog.dart';
import 'package:chatapp/Screens/HomeScreen.dart';
import 'package:chatapp/Services/Network.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';

class OtpAuthentication extends StatelessWidget {
  final String gmail, name, password;
  final prefs, messaging;

  OtpAuthentication(
      {this.gmail, this.name, this.prefs, this.messaging, this.password});

  final TextEditingController _otp = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void onPressed(BuildContext context) {
    bool check = EmailAuth.validate(receiverMail: gmail, userOTP: _otp.text);

    if (check) {
      FocusScope.of(context).unfocus();
      Map<String, dynamic> map = {
        "username": name,
        "gmail": gmail,
        "password": password,
        "image": ""
      };

      BuildContext dialogcontext = context;

      showDialog(
        context: dialogcontext,
        builder: (_) => Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Container(
            height: MediaQuery.of(context).size.height / 15,
            width: MediaQuery.of(context).size.height / 15,
            child: CircularProgressIndicator(),
          ),
        ),
      );

      registerNewUser(map).then((value) async {
        if (value == 200 || value == 201) {
          await prefs.setString('username', name).then((value) => print(value));
          await prefs.setString('gmail', gmail);
          await prefs.setString('image', "");

          String topic = gmail.substring(0, gmail.length - 10);

          print(topic);

          await messaging.subscribeToTopic(topic);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        prefs: prefs,
                      )),
              (Route<dynamic> route) => false);
          print("Correct OTP");
        } else {
          showDialog(
              context: context,
              builder: (_) => CustomDialog(
                    title: "Email Verification",
                    content:
                        "The email you are trying to create account is already registered",
                  ));
          Navigator.pop(dialogcontext);
        }
      });
    } else {
      _scaffoldKey.currentState
          // ignore: deprecated_member_use
          .showSnackBar(SnackBar(content: Text("You have enterd wrong OTP")));
      // showDialog(
      //     context: context,
      //     builder: (_) => CustomDialog(
      //           title: "OTP",
      //           content: "You have entered wrong otp",
      //         ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 236, 250, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height / 15,
            ),
            Text(
              'Chat App!',
              style: TextStyle(
                fontSize: size.width / 11,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(41, 60, 98, 1),
              ),
            ),
            SizedBox(
              height: size.height / 12,
            ),
            Text(
              "Enter Otp",
              style: TextStyle(
                fontSize: size.width / 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: size.height / 40,
            ),
            Container(
              height: size.height / 15,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 15,
                width: size.width / 1.1,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  controller: _otp,
                  decoration: InputDecoration(
                    fillColor: Colors.grey,
                    filled: true,
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    hintText: "Enter OTP",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ElevatedButton(
                onPressed: () => onPressed(context),
                child: Text("Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  primary: Color.fromRGBO(222, 139, 88, 1),
                  // primary:
                  //     Color.fromRGBO(41, 60, 98, 1),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 10,
            ),
            Container(
              height: size.height / 3,
              width: size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      'https://image.shutterstock.com/image-vector/vector-illustration-flat-linear-style-260nw-1147927685.jpg',
                    ),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Text(
              "An Otp is send to your registered email id",
              style: TextStyle(
                fontSize: size.width / 24,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
