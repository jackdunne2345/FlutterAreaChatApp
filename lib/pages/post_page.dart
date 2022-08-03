import 'package:flutter/material.dart';
import '../main.dart';
import '/firebase.dart';

class PostPage extends StatefulWidget {
  String longitude;
  String latitude;
  PostPage({Key? key, required this.longitude, required this.latitude})
      : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState(longitude, latitude);
}

class _PostPageState extends State<PostPage> {
  String longitude;
  String latitude;
  String postGive = "";
  _PostPageState(this.longitude, this.latitude);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "What you wanna tell every one?"),
                onChanged: (text) => setState(() {
                  postGive = text;
                }),
              ),
            ),
            Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      givePostData(postGive, auth.currentUser!.uid, longitude,
                          latitude, "test");
                      Navigator.pop(context);
                    },
                    child: Text('Post'))),
          ],
        ),
      ),
    );
  }
}
