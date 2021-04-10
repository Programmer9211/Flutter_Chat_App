import 'package:chatapp/Screens/SubScreen/Find.dart';
import 'package:flutter/material.dart';

import 'SubScreen/Profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(222, 139, 88, 1),
            title: Text("Chat App!"),
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.search),
                  text: "Find",
                ),
                Tab(
                  icon: Icon(Icons.chat),
                  text: "Chats",
                ),
                Tab(
                  icon: Icon(Icons.account_box),
                  text: "Profile",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Find(),
              Container(
                color: Colors.green,
              ),
              Profile()
            ],
          ),
        ));
  }
}
