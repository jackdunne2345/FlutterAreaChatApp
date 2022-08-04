import 'dart:ffi';

import 'package:flutter/material.dart';
import '../main.dart';
import '/firebase.dart';

class PostPage extends StatefulWidget {
  double longitude;
  double latitude;
  PostPage({Key? key, required this.longitude, required this.latitude})
      : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState(longitude, latitude);
}

class _PostPageState extends State<PostPage> {
  double longitude;
  double latitude;
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
                    onPressed: () async {
                      givePostData(
                          postGive,
                          auth.currentUser!.uid,
                          longitude.toString(),
                          latitude.toString(),
                          await getPostCode(longitude, latitude),
                          auth.currentUser!.email);
                      Navigator.pop(context);
                    },
                    child: Text('Post'))),
          ],
        ),
      ),
    );
  }
}

// i calcualte what post code marker youa re clsoest to using geolocator package

