import 'dart:async';
import 'dart:io';

import 'package:chatapp/Services/Network.dart';
import 'package:chatapp/bloc/chatbloc.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatScreen extends StatefulWidget {
  final String name, recieverId, senderId;
  final Socket socket;
  final ChatBloc bloc;

  ChatScreen(
      {this.name, this.recieverId, this.senderId, this.socket, this.bloc});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController scrollController;
  final TextEditingController controller = TextEditingController();
  StreamSubscription subs, statussubs;
  String status = "Offline";

  @override
  void initState() {
    super.initState();
    widget.socket.emit("status", widget.recieverId);
    scrollController = ScrollController();
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
    subs = widget.bloc.stream.listen((event) {
      setState(() {
        message.add(MessageModel(
            message: event['message'],
            senderId: event['senderId'],
            recieverId: event['recieverId']));
      });
    });

    statussubs = widget.bloc.statusStream.listen((event) {
      print(event);
      setState(() {
        status = event.toString();
      });
    });
  }

  List<MessageModel> message = [];

  void sendMessage(String mes, String senderId, String recieverId) {
    widget.socket.emit("message",
        {"message": mes, "senderId": senderId, "recieverId": recieverId});

    setState(() {
      message.add(MessageModel(
        message: mes,
        senderId: senderId,
        recieverId: recieverId,
      ));
    });

    String trimgmail = recieverId.substring(0, senderId.length - 10);

    Map<String, dynamic> map = {
      "username": trimgmail,
      "title": widget.name,
      "body": mes
    };

    sendNotifications(map);
    controller.clear();
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
    widget.socket.emit("status", widget.recieverId);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: size.height / 8,
            width: size.width / 1.1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: size.height / 12.9,
                  width: size.height / 12.9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://www.sheknows.com/wp-content/uploads/2020/12/ben-higgins-1.jpg"),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  height: size.height / 12,
                  width: size.width / 1.5,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: RichText(
                      text: TextSpan(
                          text: "${widget.name}\n",
                          style: TextStyle(
                            color: Color.fromRGBO(41, 60, 98, 1),
                            fontSize: size.width / 20,
                            fontWeight: FontWeight.w500,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: status,
                              style: TextStyle(
                                  color: Color.fromRGBO(41, 60, 98, 1),
                                  fontSize: size.width / 26),
                            )
                          ]),
                    ),
                  ),
                ),
                Container(
                  height: size.height / 12,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: Color.fromRGBO(41, 60, 98, 1),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: size.height / 1.275,
            width: size.width,
            child: ListView.builder(
              controller: scrollController,
              itemCount: message.length == null ? 1 : message.length,
              itemBuilder: (context, index) {
                return card(size, message[index].message,
                    message[index].senderId == widget.senderId ? true : false);
              },
            ),
          ),
        ],
      )),
      floatingActionButton: Container(
        height: size.height / 15,
        width: size.width / 1.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  fillColor: Colors.grey,
                  filled: true,
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  hintText: "Send Message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.send,
                  color: Color.fromRGBO(41, 60, 98, 1),
                ),
                onPressed: () => sendMessage(
                    controller.text, widget.senderId, widget.recieverId))
          ],
        ),
      ),
    );
  }

  Widget card(Size size, String message, bool isme) {
    return Container(
      width: size.width,
      alignment: isme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isme
              ? Color.fromRGBO(235, 235, 235, 1)
              : Color.fromRGBO(255, 216, 214, 1),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: isme ? Radius.circular(12) : Radius.circular(0),
              bottomRight: isme ? Radius.circular(0) : Radius.circular(12)),
        ),
        child: Text(
          message,
          style: TextStyle(
            //color: Colors.white,
            fontSize: size.width / 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    subs.cancel();
    statussubs.cancel();
    super.dispose();
  }
}

class MessageModel {
  String message, recieverId, senderId;

  MessageModel({this.message, this.recieverId, this.senderId});
}
