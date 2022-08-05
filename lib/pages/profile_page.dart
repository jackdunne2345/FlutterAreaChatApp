// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'package:area_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/firebase.dart';

class ProfilePage extends StatefulWidget {
  String uid;
  ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState(uid);
}

class _ProfilePageState extends State<ProfilePage> {
  String uid;

  _ProfilePageState(this.uid);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.95,
                child: new Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return new Image.network(
                      "http://via.placeholder.com/288x188",
                      fit: BoxFit.fill,
                    );
                  },
                  itemCount: 10,
                  viewportFraction: 0.8,
                  scale: 0.9,
                )),
            Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                //future builder builds itself based on snapshot fed inito it as it updates
                child: FutureBuilder<DocumentSnapshot>(
                  future: userData.doc(uid).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Text("${data['bio']}");
                    }

                    return Text("Loading....");
                  },
                )),
            Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: Visibility(
                    visible: auth.currentUser!.uid == uid,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              //i have to make it impossible for someone to accses this function if they dont have the corret creditials
                              builder: (context) => EditProfile(
                                    uid: uid,
                                  )));
                        },
                        child: Text('Edit Profile'))))
          ],
        ),
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  String uid;
  EditProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState(uid);
}

class _EditProfileState extends State<EditProfile> {
  String uid;
  String currentBio = "";
  _EditProfileState(this.uid);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "enter new bio"),
                onChanged: (text) => setState(() {
                  currentBio = text;
                }),
              ),
            ),
            Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      giveUserData(currentBio, uid);
                      Navigator.pop(context);
                    },
                    child: Text('Save Profile')))
          ],
        ),
      ),
    );
  }
}
