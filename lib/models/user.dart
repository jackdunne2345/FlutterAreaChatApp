import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String pic1;
  final String pic2;
  final String pic3;
  final String pic4;
  final String pic5;
  final String pic6;
  final String pp;
  final String bio;

  const User({
    required this.pic1,
    required this.pic2,
    required this.pic3,
    required this.pic4,
    required this.pic5,
    required this.pic6,
    required this.pp,
    required this.bio,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      pic1: snapshot["pic1"],
      pic2: snapshot["pic2"],
      pic3: snapshot["pic3"],
      pic4: snapshot["pic4"],
      pic5: snapshot["pic5"],
      pic6: snapshot["pic6"],
      pp: snapshot["pp"],
      bio: snapshot["bio"],
    );
  }
}
