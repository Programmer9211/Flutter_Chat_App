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
  StreamSubscription subs;

  @override
  void initState() {
    super.initState();
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
  }

  List<MessageModel> message = [];

  void sendMessage(String mes, String senderId, String recieverId) {
    widget.socket.emit("message",
        {"message": mes, "senderId": senderId, "recieverId": recieverId});

    setState(() {
      message.add(MessageModel(
          message: mes, senderId: senderId, recieverId: recieverId));
    });

    String trimgmail = senderId.substring(0, senderId.length - 10);

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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: size.height / 1.2,
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
                icon: Icon(Icons.send),
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
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isme ? Colors.amber : Colors.blue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: isme ? Radius.circular(15) : Radius.circular(0),
              bottomRight: isme ? Radius.circular(0) : Radius.circular(15)),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width / 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class MessageModel {
  String message, recieverId, senderId;

  MessageModel({this.message, this.recieverId, this.senderId});
}
