import 'package:firebase_auth/firebase_auth.dart';

Duration get loginTime => Duration(milliseconds: 2250);
Future<String?> logIn(String name, String password) async {
  try {
    FirebaseAuth.instance
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
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: name, password: password);
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
