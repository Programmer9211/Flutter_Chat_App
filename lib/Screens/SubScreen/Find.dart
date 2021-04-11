import 'dart:async';

import 'package:chatapp/Screens/SubScreen/ChatScreen.dart';
import 'package:chatapp/Services/Network.dart';
import 'package:chatapp/bloc/chatbloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class Find extends StatefulWidget {
  final SharedPreferences prefs;
  final Socket socket;
  final ChatBloc bloc;
  Find({this.prefs, this.socket, this.bloc});

  @override
  _FindState createState() => _FindState();
}

class _FindState extends State<Find> with SingleTickerProviderStateMixin {
  TextEditingController _controller = TextEditingController();
  Map<String, dynamic> userMap;
  double width;
  bool isSearching = false;
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    animation = Tween<Offset>(begin: Offset(0.0, -0.26), end: Offset.zero)
        .animate(animationController);

    Timer(Duration(milliseconds: 1), () {
      width = MediaQuery.of(context).size.width / 4.5;
      setState(() {});
      animationController.forward();
    });
  }

  void onSearch(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      setState(() {
        width = MediaQuery.of(context).size.height / 20;
      });

      Timer(Duration(milliseconds: 200), () {
        setState(() {
          isSearching = true;
        });
        getUser(_controller.text).then((value) {
          setState(() {
            userMap = value;
            isSearching = false;
            width = MediaQuery.of(context).size.width / 4.5;

            if (userMap.containsKey('gmail')) {
              animationController.reverse();
              _controller.clear();
            }
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return width == null
        ? Container()
        : Scaffold(
            body: AnimatedBuilder(
                animation: animation,
                child: Container(
                  height: size.height,
                  width: size.width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height / 20,
                      ),
                      Container(
                        height: size.height / 15,
                        width: size.width / 1.1,
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            fillColor: Colors.grey,
                            filled: true,
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            hintText: "gmail",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height / 30,
                      ),
                      isSearching
                          ? CircularProgressIndicator()
                          : AnimatedContainer(
                              height: size.height / 20,
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(200),
                              ),
                              duration: Duration(milliseconds: 200),
                              child: width != size.width / 4.5
                                  ? null
                                  : ElevatedButton(
                                      onPressed: () => onSearch(context),
                                      child: Text(
                                        "Search",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )),
                            ),
                      SizedBox(
                        height: size.height / 18,
                      ),
                      userMap == null
                          ? Container()
                          : (userMap.containsKey('msg')
                              ? Container(
                                  child: Text(userMap['msg']),
                                )
                              : ListTile(
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) => ChatScreen(
                                              bloc: widget.bloc,
                                              name: userMap['username'],
                                              recieverId: userMap['gmail'],
                                              senderId: widget.prefs
                                                  .getString('gmail'),
                                              socket: widget.socket))),
                                  title: Text(userMap['username']),
                                  subtitle: Text(userMap['gmail']),
                                )),
                    ],
                  ),
                ),
                builder: (context, child) {
                  return SlideTransition(
                    position: animation,
                    child: child,
                  );
                }),
            floatingActionButton:
                animationController.status == AnimationStatus.reverse
                    ? FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            userMap = null;
                            animationController.reset();
                            animationController.forward();
                          });
                        },
                        child: Icon(Icons.search, color: Colors.white),
                      )
                    : Container(),
          );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
