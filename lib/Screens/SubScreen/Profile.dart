import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      child: Column(
        children: [
          SizedBox(
            height: size.height / 15,
          ),
          Container(
            height: size.height / 4,
            width: size.width / 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
          ),
          SizedBox(
            height: size.height / 35,
          ),
          Text(
            "Name",
            style: TextStyle(
              fontSize: size.width / 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
