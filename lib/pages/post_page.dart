import 'dart:ffi';

import 'package:flutter/material.dart';
import '../main.dart';
import '/firebase.dart';

class PostPage extends StatefulWidget {
  String pCode;
  PostPage({Key? key, required this.pCode}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState(pCode);
}

class _PostPageState extends State<PostPage> {
  String pCode;
  String postGive = "";
  _PostPageState(this.pCode);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "What you wanna tell every one?"),
                onChanged: (text) => setState(() {
                  postGive = text;
                }),
              ),
            ),
            VerticalDivider(
              thickness: 10,
              color: Colors.white,
            ),
            SizedBox(
                height: 60,
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
                          pCode,
                          auth.currentUser!.email,
                          DateTime.now());
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

