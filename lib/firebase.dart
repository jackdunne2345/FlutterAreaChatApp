import 'package:area_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

//this object a userData object referning to the "userCollection" colelction on my firestore

final CollectionReference userData =
    FirebaseFirestore.instance.collection('userCollection');

final CollectionReference postData =
    FirebaseFirestore.instance.collection('posts');

//**************************************************************************************************************************************************** */
Future giveUserData(String name) async {
  return await userData
      .doc(signedInAuthUser.uid)
      .set({
        'bio': "Hi im new :)",
        'profilepic': signedInAuthUser.profilePic,
        'username': name,
        'pic1':
            "https://firebasestorage.googleapis.com/v0/b/area-app-8575b.appspot.com/o/newUser%2Fpic1.jpg?alt=media&token=76dc67a4-4774-4f5b-88d6-5bfb53a94c1b",
        'pic2':
            "https://firebasestorage.googleapis.com/v0/b/area-app-8575b.appspot.com/o/newUser%2Fpic2.jpg?alt=media&token=f6b8b2f8-d7f5-4e31-883d-ad06e96312e7",
        'pic3':
            "https://firebasestorage.googleapis.com/v0/b/area-app-8575b.appspot.com/o/newUser%2Fpic3.jpg?alt=media&token=9d0b4308-1048-4dc6-9ebf-5f5ef8f1ea85",
        'pic4':
            "https://firebasestorage.googleapis.com/v0/b/area-app-8575b.appspot.com/o/newUser%2Fpic4.jpg?alt=media&token=b29ef18d-1d37-4480-84d9-21d3dd7221b1",
        'pic5':
            "https://firebasestorage.googleapis.com/v0/b/area-app-8575b.appspot.com/o/newUser%2Fpic5.jpg?alt=media&token=0439199d-be93-45b0-810e-3166a5dfcf6e",
        'pic6':
            "https://firebasestorage.googleapis.com/v0/b/area-app-8575b.appspot.com/o/newUser%2Fpic6.jpg?alt=media&token=77433dc3-f956-436f-8cd5-3f40be299233",
      })
      .then((value) => print("Data added"))
      .catchError((error) => print("Failed to add data: $error"));
}
//**************************************************************************************************************************************************** */

//**************************************************************************************************************************************************** */
Future givePostData(String postText, String? uid, String postCode, String? name,
    DateTime time, String pic) async {
  return await postData.doc().set({
    'post_text': postText,
    'uid': uid,
    'name': name,
    'post_code': postCode,
    'date_time': time,
    'pic': pic
  });
}

//**************************************************************************************************************************************************** */

class AuthWithGoogle {
  final FirebaseAuth authEntrypoint = FirebaseAuth.instance;
  //**************************************************************************************************************************************************** */
  signOut() {
    signedInAuthUser = AuthUser();
    authEntrypoint.signOut();
  }
  //**************************************************************************************************************************************************** */

  //**************************************************************************************************************************************************** */
  Duration get loginTime => const Duration(milliseconds: 2250);
  //**************************************************************************************************************************************************** */

  //**************************************************************************************************************************************************** */
  Future<String?> logInEmail(String name, String password) async {
    try {
      await authEntrypoint.signInWithEmailAndPassword(
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

  Future<String?> signUpEmail(
      String name, String password, String screenName) async {
    try {
      UserCredential create = await authEntrypoint
          .createUserWithEmailAndPassword(email: name, password: password);

      signedInAuthUser.uid = FirebaseAuth.instance.currentUser!.uid;
      //set user data to default data when account is made
      await giveUserData(screenName);

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
      authEntrypoint.sendPasswordResetEmail(email: name);
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
        stream: authEntrypoint.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            signedInAuthUser.uid = FirebaseAuth.instance.currentUser!.uid;
            userData.doc(signedInAuthUser.uid).get().then((value) async {
              signedInAuthUser.name = await value['username'];
              signedInAuthUser.profilePic = await value['profilepic'];
            });
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
      signedInAuthUser = AuthUser();
      signedInAuthUser.uid = FirebaseAuth.instance.currentUser!.uid;
      //need to fix this
      DocumentSnapshot<Object?> query =
          await userData.doc(signedInAuthUser.uid).get();
      if (query.exists) {
      } else {
        await giveUserData(googleUser.displayName!);
      }
      userData.doc(signedInAuthUser.uid).get().then((value) async {
        signedInAuthUser.name = await value['username'];
        signedInAuthUser.profilePic = await value['profilepic'];
      });

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

class AuthUser {
  String uid = "";
  String profilePic = "";
  double longitude = 0.0;
  double latitude = 0.0;
  String pcode = "";
  String name = "";
  String bio = "";
  String pic1 = "";
  String pic2 = "";
  String pic3 = "";
  String pic4 = "";
  String pic5 = "";
  String pic6 = "";
}
