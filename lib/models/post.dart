import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String post_text;
  final String uid;

  const Post({
    required this.post_text,
    required this.uid,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      post_text: snapshot["post_text"],
      uid: snapshot["uid"],
    );
  }

  Map<String, dynamic> toJson() => {
        "post_text": post_text,
        "uid": uid,
      };
}
