import 'package:area_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
authUser? SignedInAuthUser;

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
            SignedInAuthUser = authUser();
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

  //upload iamges
  void uploadImage(String imageName) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('${file?.path}');
    //ROOT REFERENCE
    Reference refRoot = FirebaseStorage.instance.ref();
    Reference refDirImage = refRoot.child(SignedInAuthUser!.uid!);
    //IMAGE REFERECNE
    Reference refUploadImage = refDirImage.child(imageName);
    try {
      await refUploadImage.putFile(File(file!.path));
      String url = await refUploadImage.getDownloadURL();

      await userData
          .doc(SignedInAuthUser!.uid)
          .set({'profilepic': url})
          .then((value) => print("Data added"))
          .catchError((error) => print("Failed to add data: $error"));
    } catch (e) {
      print(e);
    }
  }
}

class authUser {
  String? uid;
  String? profilePic;
  String bio = "Hi im new!";
  String pic1 =
      "https://firebasestorage.googleapis.com/v0/b/area-app-8575b.appspot.com/o/newUser%2Fpic1.jpg?alt=media&token=76dc67a4-4774-4f5b-88d6-5bfb53a94c1b";
  String pic2 =
      "https://firebasestorage.googleapis.com/v0/b/area-app-8575b.appspot.com/o/newUser%2Fpic2.jpg?alt=media&token=f6b8b2f8-d7f5-4e31-883d-ad06e96312e7";
  String pic3 =
      "https://firebasestorage.googleapis.com/v0/b/area-app-8575b.appspot.com/o/newUser%2Fpic3.jpg?alt=media&token=9d0b4308-1048-4dc6-9ebf-5f5ef8f1ea85";
  String pic4 =
      "https://firebasestorage.googleapis.com/v0/b/area-app-8575b.appspot.com/o/newUser%2Fpic4.jpg?alt=media&token=b29ef18d-1d37-4480-84d9-21d3dd7221b1";
  String pic5 =
      "https://firebasestorage.googleapis.com/v0/b/area-app-8575b.appspot.com/o/newUser%2Fpic5.jpg?alt=media&token=0439199d-be93-45b0-810e-3166a5dfcf6e";
  String pic6 =
      "https://firebasestorage.googleapis.com/v0/b/area-app-8575b.appspot.com/o/newUser%2Fpic6.jpg?alt=media&token=77433dc3-f956-436f-8cd5-3f40be299233";
}
