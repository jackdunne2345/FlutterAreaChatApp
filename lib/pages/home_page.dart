import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'profile_page.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '/firebase.dart';

class HomePage extends StatefulWidget {
  String pCode;

  HomePage({Key? key, required this.pCode}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(pCode);
}

class _HomePageState extends State<HomePage> {
  String pCode;
  String postGive = "";
  Timestamp timeNow = Timestamp.now();
  _HomePageState(this.pCode);

  @override
  Widget build(BuildContext context) {
    updatePosition();
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('date_time', isGreaterThan: timeNow)
                  .where('post_code', isEqualTo: pCode)
                  .orderBy('date_time', descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.size == 0) {
                  return Expanded(
                      child: Center(
                          child: Text("looks like no one is talking here in " +
                              pCode)));
                } else {
                  return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              //i have to make it impossible for someone to accses this function if they dont have the corret creditials
                              builder: (context) => ProfilePage(
                                    uid: snapshot.data!.docs[index]
                                        .data()['uid'],
                                  )));
                        },
                        child: PostWidget(
                          snap: snapshot.data!.docs[index].data(),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            Visibility(
                visible: signedInAuthUser.pcode == pCode, child: TextEnter()),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.01,
            )
          ])),
    );
  }
}

class TextEnter extends StatelessWidget {
  TextEnter({super.key});

  @override
  TextEditingController textarea = TextEditingController();
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.1,
        child: TextField(
          controller: textarea,
          onEditingComplete: () async {
            await givePostData(
                textarea.text,
                signedInAuthUser.uid,
                signedInAuthUser.pcode,
                signedInAuthUser.name,
                DateTime.now(),
                signedInAuthUser.profilePic);
            textarea.clear();
          },
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "What you wanna tell every one?"),
        ),
      )
    ]);
  }
}

class PostWidget extends StatefulWidget {
  final snap;

  const PostWidget({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState(snap);
}

class _PostWidgetState extends State<PostWidget> {
  var snap;

  _PostWidgetState(this.snap);
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if ("${widget.snap['uid']}" == signedInAuthUser.uid) {
      return Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 200,
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.blue[100],
                      ),
                      child: Flexible(
                        child: Text(' ${widget.snap['post_text']}'),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      DateFormat.Hms()
                          .format(widget.snap['date_time'].toDate()),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              height: 100,
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(signedInAuthUser.name),
                  ProfilePicWidget(widget.snap['pic'], widget.snap['name']),
                ],
              ),
            )
          ],
        ),
        Divider(
            height: 10,
            thickness: 2,
            indent: 10,
            endIndent: 10,
            color: Colors.grey[200])
      ]);
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.snap['name']),
                    ProfilePicWidget(widget.snap['pic'], widget.snap['name']),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey[400],
                        ),
                        child: Flexible(
                          child: Text(widget.snap['post_text']),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        DateFormat.Hms()
                            .format(widget.snap['date_time'].toDate()),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Divider(
              height: 10,
              thickness: 2,
              indent: 10,
              endIndent: 10,
              color: Colors.grey[200])
        ],
      );
    }
  }
}
