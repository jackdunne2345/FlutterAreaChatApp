// ignore_for_file: unnecessary_new, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import '/firebase.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

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
              color: Colors.amber,
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.95,
              child: new Swiper(
//Swiper
                itemBuilder: (BuildContext context, int index) {
                  return new Image.network(
                    "http://via.placeholder.com/288x188",
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
                        builder: (context) => EditProfile(
                              uid: uid,
                            )));
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

  TextEditingController textarea = TextEditingController();

  @override
  void initState() {
    textarea.text = "test"; //default text
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfilePicture(
                name: 'Dees',
                radius: 31,
                fontsize: 27,
              ),
              TextButton(onPressed: onPressed(), child: Text("Change Avatar")),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  color: Colors.amber,
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 120,
                    height: 225,
                    child: IconButton(
                      alignment: Alignment.bottomRight,
                      icon: Icon(Icons.add_a_photo),
                      onPressed: () {},
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  color: Colors.amber,
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 120,
                    height: 225,
                    child: IconButton(
                      alignment: Alignment.bottomRight,
                      icon: Icon(Icons.add_a_photo),
                      onPressed: () {},
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  color: Colors.amber,
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 120,
                    height: 225,
                    child: IconButton(
                      alignment: Alignment.bottomRight,
                      icon: Icon(Icons.add_a_photo),
                      onPressed: () {},
                    ),
                  ),
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  color: Colors.amber,
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 120,
                    height: 225,
                    child: IconButton(
                      alignment: Alignment.bottomRight,
                      icon: Icon(Icons.add_a_photo),
                      onPressed: () {},
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  color: Colors.amber,
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 120,
                    height: 225,
                    child: IconButton(
                      alignment: Alignment.bottomRight,
                      icon: Icon(Icons.add_a_photo),
                      onPressed: () {},
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  color: Colors.amber,
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 120,
                    height: 225,
                    child: IconButton(
                      alignment: Alignment.bottomRight,
                      icon: Icon(Icons.add_a_photo),
                      onPressed: () {},
                    ),
                  ),
                ),
              ]),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                      hintText:
                          "enter new bio mhfabfkanjfladskfsdnfg a fklafjlada; falfafdl.akfalijfalo    alfjklafkalf ajliiaf"),
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
      ),
    );
  }

  onPressed() {}
}
