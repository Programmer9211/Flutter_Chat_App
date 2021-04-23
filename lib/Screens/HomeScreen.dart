import 'package:chatapp/Authenticate/WelcomeScreen.dart';
import 'package:chatapp/Screens/SubScreen/Chats.dart';
import 'package:chatapp/Screens/SubScreen/Find.dart';
import 'package:chatapp/bloc/chatbloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:chatapp/Services/Network.dart';

import 'SubScreen/Profile.dart';

class HomeScreen extends StatefulWidget {
  final SharedPreferences prefs;
  HomeScreen({this.prefs});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  IO.Socket sockets;
  final ChatBloc _bloc = ChatBloc();
  FirebaseMessaging messenging = FirebaseMessaging.instance;
  Map<String, dynamic> fill = Map<String, dynamic>();
  List<Map<String, dynamic>> userChatList;
  List isUserAvalible;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      sockets.emit("signout", widget.prefs.getString('gmail'));
      print(state);
    } else if (state == AppLifecycleState.resumed) {
      sockets.emit("signin", widget.prefs.getString('gmail'));
      print(state);
    } else if (state == AppLifecycleState.detached) {
      sockets.emit("signout", widget.prefs.getString('gmail'));
      print(state);
    } else if (state == AppLifecycleState.paused) {
      sockets.emit("signout", widget.prefs.getString('gmail'));
      print(state);
    } else {
      sockets.emit("signout", widget.prefs.getString('gmail'));
      print(state);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    conectSocket();
    getUserList();
  }

  void getUserList() {
    setState(() {
      userChatList = [];
      isUserAvalible = [];
    });
    recentChats(widget.prefs.getString('gmail')).then((chatList) {
      print(widget.prefs.getString('gmail'));
      if (chatList != null) {
        for (int i = 0; i <= chatList.length - 1; i++) {
          isUserAvalible.add(chatList[i]['chats']);
          setState(() {});
        }
        for (int i = 0; i <= chatList.length - 1; i++) {
          getUser(chatList[i]['chats']).then((userMap) {
            userChatList.add(userMap);
            setState(() {});
            print(userChatList);
          });
        }
      }
    });
  }

  void conectSocket() {
    sockets =
        IO.io('http://glacial-shore-29640.herokuapp.com', <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false
    });

    sockets.connect();
    sockets.onConnect((data) {
      print("connected");
      sockets.on("message", (msg) {
        print(msg);
        _bloc.controller.add(msg);
      });
      _bloc.idStream.listen((event) {
        print(event);
        sockets.on(event, (data) {
          print(data);
          _bloc.statusController.add(data.toString());
        });
      });
    });

    print(sockets.connected);
    sockets.emit("login", widget.prefs.getString('gmail'));
    sockets.emit("signin", widget.prefs.getString('gmail'));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(
                  Icons.logout,
                  size: MediaQuery.of(context).size.width / 18,
                  color: Color.fromRGBO(41, 60, 98, 1),
                ),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (_) => Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Container(
                              height: MediaQuery.of(context).size.height / 15,
                              width: MediaQuery.of(context).size.height / 15,
                              child: CircularProgressIndicator(),
                            ),
                          ));

                  String gmail = widget.prefs.getString('gmail');
                  await widget.prefs.clear().then((value) async {
                    if (value) {
                      sockets.emit("signout", gmail);
                      String topic = gmail.substring(0, gmail.length - 10);

                      await messenging.unsubscribeFromTopic(topic).then(
                            (value) => Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        WelcomeScreen(widget.prefs)),
                                (Route<dynamic> route) => false),
                          );
                    }
                  });
                },
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 20,
              ),
            ],
            backgroundColor: Colors.white,
            //backgroundColor: Color.fromRGBO(255, 171, 55, 1),
            title: Text(
              "Chat App!",
              style: TextStyle(color: Color.fromRGBO(41, 60, 98, 1)),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.search,
                    color: Color.fromRGBO(41, 60, 98, 1),
                  ),
                  child: Text(
                    "Find",
                    style: TextStyle(color: Color.fromRGBO(41, 60, 98, 1)),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.chat,
                    color: Color.fromRGBO(41, 60, 98, 1),
                  ),
                  child: Text(
                    "Chats",
                    style: TextStyle(
                      color: Color.fromRGBO(41, 60, 98, 1),
                    ),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.account_box,
                    color: Color.fromRGBO(41, 60, 98, 1),
                  ),
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      color: Color.fromRGBO(41, 60, 98, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Find(
                hompageFunction: getUserList,
                socket: sockets,
                prefs: widget.prefs,
                bloc: _bloc,
                chatList: isUserAvalible,
              ),
              RecentChats(
                chatList: userChatList,
                socket: sockets,
                block: _bloc,
                prefs: widget.prefs,
              ),
              Profile(
                name: widget.prefs.getString('username'),
                gmail: widget.prefs.getString('gmail'),
                prefs: widget.prefs,
              )
            ],
          ),
        ));
  }
}
