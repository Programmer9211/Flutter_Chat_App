import 'dart:io';

import 'package:chatapp/Services/Network.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final String name, gmail;
  final SharedPreferences prefs;

  Profile({this.name, this.gmail, this.prefs});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;
  File imageFile;

  Future getImageFile() async {
    final imagepicker = ImagePicker();

    await imagepicker.getImage(source: ImageSource.gallery).then((value) {
      setState(() {
        imageFile = File(value.path);
      });
      uploadImage();
    });
  }

  Future uploadImage() async {
    firebaseStorage.Reference ref =
        firebaseStorage.FirebaseStorage.instance.ref().child('images/');

    firebaseStorage.UploadTask uploadTask = ref.putFile(imageFile);

    await uploadTask.snapshot.ref.getDownloadURL().then((value) {
      if (value != null) {
        print(value);
        Map<String, dynamic> map = {"gmail": widget.gmail, "image": value};
        uploadImageLink(map).then((maps) async {
          print(maps);
          if (maps['msg'] == "Image Updated Sucessfully") {
            await widget.prefs.setString('image', value).then((value) {
              setState(() {});
            });
          }
        });
      } else {
        print("Error on uploading image");
      }
    });
  }

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    animation = Tween(begin: Offset(0.0, -1.0), end: Offset.zero)
        .animate(animationController);

    animationController.forward();
  }

  void onClick() {
    final size = MediaQuery.of(context).size;

    showDialog(
        context: context,
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: size.height / 6,
                width: size.width / 4,
                child: Column(
                  children: [
                    ListTile(
                      onTap: getImageFile,
                      leading: Text("1"),
                      title: Text("Upload Image"),
                      trailing: Icon(Icons.upload_file),
                    ),
                    ListTile(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ViewImage(
                                imageUrl: widget.prefs.getString('image') == ""
                                    ? 'https://www.sheknows.com/wp-content/uploads/2020/12/ben-higgins-1.jpg'
                                    : widget.prefs.getString('image'),
                                name: widget.name,
                              ))),
                      leading: Text("2"),
                      title: Text("View Image"),
                      trailing: Icon(Icons.photo),
                    ),
                  ],
                ),
              ),
            ));
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
                    color: Color.fromRGBO(41, 60, 98, 1),
                    fontSize: size.width / 18,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(
                height: size.height / 30,
              ),
              GestureDetector(
                onTap: onClick,
                child: Material(
                  elevation: 15,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: size.height / 3,
                    width: size.width / 1.5,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: NetworkImage(
                            widget.prefs.getString('image') == ""
                                ? 'https://www.sheknows.com/wp-content/uploads/2020/12/ben-higgins-1.jpg'
                                : widget.prefs.getString('image'),
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 35,
              ),
              Text(
                widget.name,
                style: TextStyle(
                  color: Color.fromRGBO(41, 60, 98, 1),
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
                  color: Color.fromRGBO(41, 60, 98, 1),
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

class ViewImage extends StatelessWidget {
  final String name, imageUrl;

  ViewImage({this.imageUrl, this.name});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: Container(
          height: size.height / 2,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              //s fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
