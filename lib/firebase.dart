import 'package:area_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '/pages/img_change.dart';
import 'dart:io';

//this object a userData object referning to the "userCollection" colelction on my firestore

final CollectionReference userData =
    FirebaseFirestore.instance.collection('userCollection');

final CollectionReference postData =
    FirebaseFirestore.instance.collection('posts');

//**************************************************************************************************************************************************** */
Future giveUserData() async {
  return await userData
      .doc(SignedInAuthUser!.uid)
      .set({
        'bio': SignedInAuthUser!.bio,
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
}
//**************************************************************************************************************************************************** */

//**************************************************************************************************************************************************** */
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

//**************************************************************************************************************************************************** */

class AuthWithGoogle {
  final FirebaseAuth Auth_Entry_point = FirebaseAuth.instance;
  //**************************************************************************************************************************************************** */
  signOut() {
    SignedInAuthUser = null;
    Auth_Entry_point.signOut();
  }
  //**************************************************************************************************************************************************** */

  //**************************************************************************************************************************************************** */
  Duration get loginTime => Duration(milliseconds: 2250);
  //**************************************************************************************************************************************************** */

  //**************************************************************************************************************************************************** */
  Future<String?> logInEmail(String name, String password) async {
    try {
      await Auth_Entry_point.signInWithEmailAndPassword(
          email: name, password: password);
      return Future.delayed(loginTime).then((_) {
        return null;
      });
    } on FirebaseAuthException catch (e) {
      return Future.delayed(loginTime).then((_) {
        return e.message;
      });
    }
  }
  //**************************************************************************************************************************************************** */

  Future<String?> signUpEmail(String name, String password) async {
    try {
      UserCredential create =
          await Auth_Entry_point.createUserWithEmailAndPassword(
              email: name, password: password);

      SignedInAuthUser = authUser();
      SignedInAuthUser!.uid = FirebaseAuth.instance.currentUser!.uid;
      //set user data to default data when account is made
      giveUserData();

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

  //**************************************************************************************************************************************************** */

  //password reset using firebase
  Future<String?> forgotPassword(String name) async {
    try {
      Auth_Entry_point.sendPasswordResetEmail(email: name);
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
  //**************************************************************************************************************************************************** */

  //**************************************************************************************************************************************************** */
  //uses a stream builder to build the applciation scaffold based on weather the snapshot of the stream has data in it
  // in this case user auth data.

  handleAuthState() {
    return StreamBuilder(
        stream: Auth_Entry_point.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            SignedInAuthUser!.uid = FirebaseAuth.instance.currentUser!.uid;

            return HomeView();
          } else {
            return LoginScreen();
          }
        });
  }

  //allows ussers to sign in with google
  Future<String?> signIn() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["email"]).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      SignedInAuthUser = authUser();
      SignedInAuthUser!.uid = FirebaseAuth.instance.currentUser!.uid;
      //need to fix this
      giveUserData();
      return Future.delayed(loginTime).then((_) {
        return null;
      });
    } on FirebaseAuthException catch (e) {
      return Future.delayed(loginTime).then((_) {
        return e.message;
      });
    }
  }
}

class authUser {
  String? uid;
  String? profilePic;
  double longitude = 0.0;
  double latitude = 0.0;
  String? pcode;
  String? iso;
  String? bio;
  File? pic1;
  File? pic2;
  File? pic3;
  File? pic4;
  File? pic5;
  File? pic6;
}
