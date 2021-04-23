import 'package:chatapp/Screens/SubScreen/ChatScreen.dart';
import 'package:chatapp/bloc/chatbloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class RecentChats extends StatelessWidget {
  final List chatList;
  final Socket socket;
  final ChatBloc block;
  final SharedPreferences prefs;

  RecentChats({this.chatList, this.socket, this.block, this.prefs});

  void onTap(BuildContext context, int index) {
    if (chatList.isNotEmpty || chatList != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ChatScreen(
                name: chatList[index]['username'],
                recieverId: chatList[index]['gmail'],
                senderId: prefs.getString('gmail'),
                socket: socket,
                bloc: block,
                imageUrl: chatList[index]['image'],
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      alignment: Alignment.center,
      child: chatList == null
          ? Text("No Recent Chats")
          : ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => onTap(context, index),
                  leading: Container(
                    height: size.height / 15,
                    width: size.height / 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                            chatList[index]['image'] == ""
                                ? "https://www.sheknows.com/wp-content/uploads/2020/12/ben-higgins-1.jpg"
                                : chatList[index]['image'],
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                  title: Text(chatList[index]['username']),
                  subtitle: Text(chatList[index]['gmail']),
                );
              },
            ),
    );
  }
}
