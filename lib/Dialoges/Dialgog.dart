import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, content;
  final Color color;

  const CustomDialog({Key key, this.title, this.content, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: color == null ? Colors.orange[400] : color,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        // ignore: deprecated_member_use
        FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "ok",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
