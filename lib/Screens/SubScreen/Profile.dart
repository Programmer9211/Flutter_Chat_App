import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  String name, gmail;

  Profile({this.name, this.gmail});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    animation = Tween(begin: Offset(0.0, -1.0), end: Offset.zero)
        .animate(animationController);

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
        animation: animation,
        child: Container(
          height: size.height,
          width: size.width,
          //color: Color.fromRGBO(81, 223, 232, 1),
          child: Column(
            children: [
              SizedBox(
                height: size.height / 30,
              ),
              Text("Your Profile",
                  style: TextStyle(
                    //color: Colors.white,
                    fontSize: size.width / 18,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(
                height: size.height / 30,
              ),
              Material(
                elevation: 15,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: size.height / 3,
                  width: size.width / 1.5,
                  decoration: BoxDecoration(
                      //shape: BoxShape.circle,
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://www.sheknows.com/wp-content/uploads/2020/12/ben-higgins-1.jpg'),
                          fit: BoxFit.cover)),
                ),
              ),
              SizedBox(
                height: size.height / 35,
              ),
              Text(
                widget.name,
                style: TextStyle(
                  //  color: Colors.white,
                  fontSize: size.width / 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: size.height / 60,
              ),
              Text(
                widget.gmail,
                style: TextStyle(
                  //  color: Colors.white,
                  fontSize: size.width / 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        builder: (context, child) {
          return SlideTransition(
            position: animation,
            child: child,
          );
        });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
