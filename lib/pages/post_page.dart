import 'package:flutter/material.dart';
import '/firebase.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    String post = "";
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  border: const OutlineInputBorder(), hintText: "enter post"),
              onChanged: (text) => setState(() {
                post = text;
              }),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: () {
                // givePostData(post, auth.currentUser?.uid,
                // _determinePosition();
              },
              child: Text('post'),
            ),
          )
        ],
      ),
    );
  }
}
