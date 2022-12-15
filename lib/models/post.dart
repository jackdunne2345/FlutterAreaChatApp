import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String post_text;
  final String uid;
  final String email;
  final Timestamp date_time;
  final String post_code;

  const Post(
      {required this.post_text,
      required this.uid,
      required this.email,
      required this.date_time,
      required this.post_code});

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        post_text: snapshot["post_text"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        date_time: snapshot["date_time"],
        post_code: snapshot["post_code"]);
  }

  Map<String, dynamic> toJson() => {
        "post_text": post_text,
        "uid": uid,
        "date_time": date_time,
        "email": email
      };
}
