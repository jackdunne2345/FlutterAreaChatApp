// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:image_picker/image_picker.dart';
import '/firebase.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:area_app/main.dart';
import 'package:provider/provider.dart';
import 'img_change.dart';

class ProfilePage extends StatefulWidget {
  String uid;

  ProfilePage({Key? key, required this.uid}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState(uid);
}

//
//
//put some comments here
//
//

class _ProfilePageState extends State<ProfilePage> {
//
  String uid;

  _ProfilePageState(this.uid);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              alignment: Alignment.topLeft,
              color: Colors.blue[300],
              child: Row(
                children: const [
                  ProfilePicture(
                    name: 'Dees',
                    radius: 31,
                    fontsize: 27,
                  ),
                  SizedBox(width: 5),
                  Text(
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      "Dees")
                ],
              ),
            ),
            Container(
              color: Colors.grey,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.95,
              child: new Swiper(
//Swiper
                itemBuilder: (BuildContext context, int index) {
                  return new Image.network(
                    "https://wonderfulengineering.com/wp-content/uploads/2014/07/Landscape-wallpapers-15.jpg",
                    fit: BoxFit.fill,
                  );
                },
                itemCount: 10,
                viewportFraction: 0.8,
                scale: 0.9,
              ),
            ),
//
//Bio Container
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              //future builder builds itself based on future value returned from the snapshot
              child: FutureBuilder<DocumentSnapshot>(
                future: userData.doc(uid).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    if (data['bio'] != null) {
                      return Text(
                          style: TextStyle(fontSize: 15), "${data['bio']}");
                    } else {
                      return Text("error");
                    }
                  }

                  return Text("Loading....");
                },
              ),
            ),
//
//Edit profile button container
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              child: Visibility(
                visible:
                    AuthWithGoogle().Auth_Entry_point.currentUser!.uid == uid,
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
//
//Edit on pressed
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        //i have to make it impossible for someone to accses this function if they dont have the corret creditials
                        builder: (context) => EditProfile()));
                  },
                  child: Text('Edit Profile'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});
  @override
  Widget build(BuildContext context) {
    userData.doc(SignedInAuthUser!.uid).get().then((value) {
      Provider.of<imgChange>(context, listen: false).setPic1 = value['pic1'];
      Provider.of<imgChange>(context, listen: false).setPic2 = value['pic2'];
      Provider.of<imgChange>(context, listen: false).setPic3 = value['pic3'];
      Provider.of<imgChange>(context, listen: false).setPic4 = value['pic4'];
      Provider.of<imgChange>(context, listen: false).setPic5 = value['pic5'];
      Provider.of<imgChange>(context, listen: false).setPic6 = value['pic6'];
      Provider.of<imgChange>(context, listen: false).setPP =
          value['profilepic'];
    });

    return Consumer<imgChange>(builder: (_, provider, __) {
      return GridViewWidget();
    });
  }
}

Future<String> uploadImage() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
  print(file!.path);
  return file.path;
}

class GridViewWidget extends StatelessWidget {
  const GridViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(actions: [
          TextButton(
              onPressed: () {},
              child: Text(style: TextStyle(color: Colors.white), "Save")),
          TextButton(
              onPressed: () {},
              child: Text(style: TextStyle(color: Colors.white), "Discard")),
        ]),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfilePicWidget(context.watch<imgChange>().pp),
              TextButton(onPressed: () {}, child: Text("Change Avatar")),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 120,
                  height: 215,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(),
                  child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        Center(child: CircularProgressIndicator()),
                        ImageWidget(context.watch<imgChange>().pic1),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[700],
                          ),
                          child: IconButton(
                            onPressed: () async {
                              Provider.of<imgChange>(context, listen: false)
                                  .setPic1 = await uploadImage();
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                ),
                Container(
                  width: 120,
                  height: 215,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        Center(child: CircularProgressIndicator()),
                        ImageWidget(context.watch<imgChange>().pic2),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[700],
                          ),
                          child: IconButton(
                            onPressed: () async {
                              Provider.of<imgChange>(context, listen: false)
                                  .setPic2 = await uploadImage();
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                ),
                Container(
                  width: 120,
                  height: 215,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        Center(child: CircularProgressIndicator()),
                        ImageWidget(context.watch<imgChange>().pic3),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[700],
                          ),
                          child: IconButton(
                            onPressed: () async {
                              Provider.of<imgChange>(context, listen: false)
                                  .setPic3 = await uploadImage();
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 120,
                  height: 215,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        Center(child: CircularProgressIndicator()),
                        ImageWidget(context.watch<imgChange>().pic4),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[700],
                          ),
                          child: IconButton(
                            onPressed: () async {
                              Provider.of<imgChange>(context, listen: false)
                                  .setPic4 = await uploadImage();
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                ),
                Container(
                  width: 120,
                  height: 215,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        Center(child: CircularProgressIndicator()),
                        ImageWidget(context.watch<imgChange>().pic5),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[700],
                          ),
                          child: IconButton(
                            onPressed: () async {
                              Provider.of<imgChange>(context, listen: false)
                                  .setPic5 = await uploadImage();
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                ),
                Container(
                  width: 120,
                  height: 215,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        Center(child: CircularProgressIndicator()),
                        ImageWidget(context.watch<imgChange>().pic6),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[700],
                          ),
                          child: IconButton(
                            onPressed: () async {
                              Provider.of<imgChange>(context, listen: false)
                                  .setPic6 = await uploadImage();
                            },
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                ),
              ]),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: TextField(
                    decoration: InputDecoration(
                        hintText:
                            "enter new bio mhfabfkanjfladskfsdnfg a fklafjlada; falfafdl.akfalijfalo    alfjklafkalf ajliiaf")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

ImageProvider<Object> displayPicture(String? image) {
  if (image!.contains("https://")) {
    return NetworkImage(image);
  } else {
    return FileImage(File(image));
  }
}

class ImageWidget extends StatelessWidget {
  ImageWidget(this.pic, {super.key});
  String pic;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: Colors.blueGrey, width: 2, style: BorderStyle.solid),
            left: BorderSide(
                color: Colors.blueGrey, width: 2, style: BorderStyle.solid),
            right: BorderSide(
                color: Colors.blueGrey, width: 2, style: BorderStyle.solid),
            bottom: BorderSide(
                color: Colors.blueGrey, width: 2, style: BorderStyle.solid)),
        image: DecorationImage(image: displayPicture(pic), fit: BoxFit.cover),
      ),
    );
  }
}

class ProfilePicWidget extends StatelessWidget {
  const ProfilePicWidget(this.pic, {super.key});
  final String pic;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProfilePicture(
          name: 'Dees',
          radius: 25,
          fontsize: 27,
          img: SignedInAuthUser!.profilePic,
        ),
        Visibility(
          visible: context.watch<imgChange>().pp != "",
          child: CircularProfileAvatar(
            '',
            borderColor: Colors.purpleAccent,
            borderWidth: 5,
            elevation: 2,
            radius: 50,
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(image: displayPicture(pic)))),
          ),
        )
      ],
    );
  }
}
