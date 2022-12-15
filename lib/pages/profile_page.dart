// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    return FutureBuilder<DocumentSnapshot>(
      future: userData.doc(uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          var images = [
            data['pic1'],
            data['pic2'],
            data['pic3'],
            data['pic4'],
            data['pic5'],
            data['pic6'],
          ];

          String name = data['bio'];
          String bio = data['bio'];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                alignment: Alignment.topLeft,
                color: Colors.blue[300],
                child: Row(
                  children: [
                    ProfilePicture(
                      name: name,
                      radius: 31,
                      fontsize: 27,
                    ),
                    SizedBox(width: 5),
                    Text(
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        name)
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.95,
                child: new Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                        child: Image(image: NetworkImage(images[index])));
                  },
                  pagination: new SwiperPagination(),
                  control: new SwiperControl(),
                  itemCount: images.length,
                  viewportFraction: 0.8,
                  scale: 0.9,
                ),
              ),
              Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  //future builder builds itself based on future value returned from the snapshot
                  child:
                      Text(style: TextStyle(fontSize: 15), "${data['bio']}")),
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
          );
        } else {
          return Text("loading");
        }
      },
    );
  }
}

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});
  @override
  Widget build(BuildContext context) {
    userData.doc(SignedInAuthUser!.uid).get().then((value) {
      Provider.of<imgChange>(context, listen: false).setPic1 = value['pic1'];
      SignedInAuthUser!.pic1 = value['pic1'];
      Provider.of<imgChange>(context, listen: false).setPic2 = value['pic2'];
      SignedInAuthUser!.pic2 = value['pic2'];
      Provider.of<imgChange>(context, listen: false).setPic3 = value['pic3'];
      SignedInAuthUser!.pic3 = value['pic3'];
      Provider.of<imgChange>(context, listen: false).setPic4 = value['pic4'];
      SignedInAuthUser!.pic4 = value['pic4'];
      Provider.of<imgChange>(context, listen: false).setPic5 = value['pic5'];
      SignedInAuthUser!.pic5 = value['pic5'];
      Provider.of<imgChange>(context, listen: false).setPic6 = value['pic6'];
      SignedInAuthUser!.pic6 = value['pic6'];
      Provider.of<imgChange>(context, listen: false).setPP =
          value['profilepic'];
      SignedInAuthUser!.profilePic = value['profilepic'];
      Provider.of<imgChange>(context, listen: false).setBio = value['bio'];
      SignedInAuthUser!.bio = value['bio'];
    });

    return Consumer<imgChange>(builder: (_, provider, __) {
      return GridViewWidget();
    });
  }
}

Future<String> uploadImage() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

  return file!.path;
}

class GridViewWidget extends StatelessWidget {
  GridViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String bio = context.watch<imgChange>().bio;
    String pp = context.watch<imgChange>().pp;
    String pic1 = context.watch<imgChange>().pic1;
    String pic2 = context.watch<imgChange>().pic2;
    String pic3 = context.watch<imgChange>().pic3;
    String pic4 = context.watch<imgChange>().pic4;
    String pic5 = context.watch<imgChange>().pic5;
    String pic6 = context.watch<imgChange>().pic6;
    TextEditingController textarea = TextEditingController();
    textarea.text = context.watch<imgChange>().bio;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(actions: [
          TextButton(
              onPressed: () async {
                Reference refRoot = FirebaseStorage.instance.ref();
                Reference userFolder = refRoot.child(SignedInAuthUser!.uid!);
                if (pic1.startsWith("https://")) {
                } else {
                  try {
                    Reference imgToUpload = userFolder.child('pic1');
                    await imgToUpload.putFile(File(pic1));
                    String url = await imgToUpload.getDownloadURL();
                    SignedInAuthUser!.pic1 = url;
                  } catch (error) {
                    print(error.toString());
                  }
                }
                if (pic2.startsWith("https://")) {
                } else {
                  Reference imgToUpload = userFolder.child('pic2');
                  await imgToUpload.putFile(File(pic2));
                  String url = await imgToUpload.getDownloadURL();
                  SignedInAuthUser!.pic2 = url;
                }
                if (pic3.startsWith("https://")) {
                } else {
                  Reference imgToUpload = userFolder.child('pic3');
                  await imgToUpload.putFile(File(pic3));
                  String url = await imgToUpload.getDownloadURL();
                  SignedInAuthUser!.pic3 = url;
                }
                if (pic4.startsWith("https://")) {
                } else {
                  Reference imgToUpload = userFolder.child('pic4');
                  await imgToUpload.putFile(File(pic4));
                  String url = await imgToUpload.getDownloadURL();
                  SignedInAuthUser!.pic4 = url;
                }

                if (pic4.startsWith("https://")) {
                } else {
                  Reference imgToUpload = userFolder.child('pic5');
                  await imgToUpload.putFile(File(pic5));
                  String url = await imgToUpload.getDownloadURL();
                  SignedInAuthUser!.pic5 = url;
                }

                if (pic6.startsWith("https://")) {
                } else {
                  Reference imgToUpload = userFolder.child('pic6');
                  await imgToUpload.putFile(File(pic6));
                  String url = await imgToUpload.getDownloadURL();
                  SignedInAuthUser!.pic6 = url;
                }
                if (pp.startsWith("https://")) {
                } else if (pp == "") {
                } else {
                  Reference imgToUpload = userFolder.child('ProfilePic');
                  await imgToUpload.putFile(File(pp));
                  String url = await imgToUpload.getDownloadURL();
                  SignedInAuthUser!.profilePic = url;
                }

                userData
                    .doc(SignedInAuthUser!.uid)
                    .set({
                      'bio': textarea.text,
                      'profilepic': SignedInAuthUser!.profilePic,
                      'pic1': SignedInAuthUser!.pic1,
                      'pic2': SignedInAuthUser!.pic2,
                      'pic3': SignedInAuthUser!.pic3,
                      'pic4': SignedInAuthUser!.pic4,
                      'pic5': SignedInAuthUser!.pic5,
                      'pic6': SignedInAuthUser!.pic6,
                    })
                    .then((value) => print("Data added"))
                    .catchError((error) => print("Failed to add data: $error"));
              },
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
              TextButton(
                  onPressed: () async {
                    Provider.of<imgChange>(context, listen: false).setPP =
                        await uploadImage();
                  },
                  child: Text("Change Avatar")),
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
                        ImageWidget(pic1),
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
                        ImageWidget(pic2),
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
                        ImageWidget(pic3),
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
                        ImageWidget(pic4),
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
                        ImageWidget(pic5),
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
                        ImageWidget(pic6),
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
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.all(10),
                child: Text(
                  "About: ",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
              Container(
                color: Colors.blue[50],
                width: 500,
                margin: const EdgeInsets.all(10),
                child: Flexible(
                    child: TextField(maxLines: 8, controller: textarea)),
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
