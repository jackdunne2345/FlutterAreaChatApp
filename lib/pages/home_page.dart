import 'package:area_app/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  String pCode;

  HomePage({Key? key, required this.pCode}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(pCode);
}

class _HomePageState extends State<HomePage> {
  String pCode;
  Timestamp timeNow = Timestamp.now();
  _HomePageState(this.pCode);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('post_code', isEqualTo: pCode)
            .where('date_time', isGreaterThan: timeNow)
            .orderBy('date_time', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    //i have to make it impossible for someone to accses this function if they dont have the corret creditials
                    builder: (context) => ProfilePage(
                          uid: snapshot.data!.docs[index].data()['uid'],
                        )));
              },
              child: Container(
                child: PostWidget(
                  snap: snapshot.data!.docs[index].data(),
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}

class PostWidget extends StatefulWidget {
  final snap;

  const PostWidget({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.grey[200],
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text:
                        "${widget.snap['email']}: ${DateFormat.Hms().format(widget.snap['date_time'].toDate())}: ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' ${widget.snap['post_text']}',
                  )
                ],
              ),
            ),
          ),
          Divider(
              height: 10,
              thickness: 2,
              indent: 20,
              endIndent: 10,
              color: Colors.blue[100])
        ],
      ),
    );
  }
}
