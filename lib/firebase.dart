import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Duration get loginTime => Duration(milliseconds: 2250);
Future<String?> logIn(String name, String password) async {
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

Future<String?> signUp(String name, String password) async {
  try {
    UserCredential create = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: name, password: password);
    User user = create.user!;
    //set user data to default data when account is made
    String defBio = "Hi! I'm new :)";
    giveData(defBio, user.uid);

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

Future giveData(String bio, String uid) async {
  return await userData.doc(uid).set({'bio': bio});
}
