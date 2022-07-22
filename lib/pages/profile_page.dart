// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/firebase.dart';

class ProfilePage extends StatefulWidget {
  User user;
  ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState(user);
}

class _ProfilePageState extends State<ProfilePage> {
  User user;

  _ProfilePageState(this.user);
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
                //stream builder builds itself based on snapshot fed inito it as it updates
                child: FutureBuilder<DocumentSnapshot>(
                  future: userData.doc(user.uid).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text("Document does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Text("${data['bio']}");
                    }

                    return Text("loading");
                  },
                )),
            Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          //i have to make it impossible for someone to accses this function if they dont have the corret creditials
                          builder: (context) => EditProfile(
                                user: user,
                              )));
                    },
                    child: Text('Edit Profile')))
          ],
        ),
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  User user;
  EditProfile({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState(user);
}

class _EditProfileState extends State<EditProfile> {
  User user;
  String currentBio = "";
  _EditProfileState(this.user);
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
                      giveUserData(currentBio, user.uid);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                user: user,
                              )));
                    },
                    child: Text('Save Profile')))
          ],
        ),
      ),
    );
  }
}
