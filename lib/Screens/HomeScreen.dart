import 'package:chatapp/Screens/SubScreen/Find.dart';
import 'package:chatapp/bloc/chatbloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'SubScreen/Profile.dart';

class HomeScreen extends StatefulWidget {
  final SharedPreferences prefs;
  HomeScreen({this.prefs});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  IO.Socket sockets;
  final _bloc = ChatBloc();

  @override
  void initState() {
    super.initState();
    conectSocket();
  }

  void conectSocket() {
    sockets =
        IO.io('https://glacial-shore-29640.herokuapp.com', <String, dynamic>{
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
    });
    print(sockets.connected);
    sockets.emit("login", widget.prefs.getString('gmail'));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: null,
            backgroundColor: Color.fromRGBO(255, 171, 55, 1),
            title: Text(
              "Chat App!",
              style: TextStyle(color: Colors.white),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  child: Text(
                    "Find",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                  icon: Icon(Icons.chat, color: Colors.white),
                  child: Text(
                    "Chats",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                  icon: Icon(Icons.account_box, color: Colors.white),
                  //text: "Profile",
                  child: Text(
                    "Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Find(socket: sockets, prefs: widget.prefs, bloc: _bloc),
              Container(
                color: Colors.green,
              ),
              Profile(
                name: widget.prefs.getString('username'),
                gmail: widget.prefs.getString('gmail'),
              )
            ],
          ),
        ));
  }
}
