import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.amber[600],
          body: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return new Image.network(
                "http://via.placeholder.com/288x188",
                fit: BoxFit.fill,
              );
            },
            itemCount: 10,
            viewportFraction: 0.8,
            scale: 0.9,
          )),
    );
  }
}
