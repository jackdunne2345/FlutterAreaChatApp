import 'package:area_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Duration get loginTime => Duration(milliseconds: 2250);
Future<String?> LogIn(String name, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: name, password: password);
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  } on FirebaseAuthException catch (e) {
    return Future.delayed(loginTime).then((_) {
      return e.message;
    });
  }
}

Future<String?> SignUp(String name, String password) async {
  try {
    UserCredential create = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: name, password: password);
    User user = create.user!;
    //set user data to default data when account is made
    String defBio = "Hi! I'm new :)";
    giveUserData(defBio, user.uid);

    return Future.delayed(loginTime).then((_) async {
      //this null retunr means there is no errors and will laucnh app
      return null;
    });
  } on FirebaseAuthException catch (e) {
    return Future.delayed(loginTime).then((_) async {
      //this return means there is an error and th error will display
      return e.message;
    });
  }
}

//password reset using firebase
Future<String?> ForgotPassword(String name) async {
  try {
    auth.sendPasswordResetEmail(email: name);
    return Future.delayed(loginTime).then((_) async {
      //this null retunr means there is no errors and will laucnh app
      return null;
    });
  } on FirebaseAuthException catch (e) {
    return Future.delayed(loginTime).then((_) async {
      //this return means there is an error and th error will display
      return e.message;
    });
  }
}

//this object a userData object referning to the "userCollection" colelction on my firestore

final CollectionReference userData =
    FirebaseFirestore.instance.collection('userCollection');

final CollectionReference postData =
    FirebaseFirestore.instance.collection('posts');

Future giveUserData(String bio, String uid) async {
  return await userData.doc(uid).set({'bio': bio});
  //  .then((value) => print("Data added"))
  // .catchError((error) => print("Failed to add data: $error"));
}

Future givePostData(String postText, String? uid, String longitude,
    String latitude, String countryCode, String? email, DateTime time) async {
  return await postData.doc().set({
    'post_text': postText,
    'longitude': longitude,
    'latitude': latitude,
    'uid': uid,
    'email': email,
    'post_code': countryCode,
    'date_time': time
  });
}
