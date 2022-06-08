// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:area_app/pages/chat_page.dart';
import 'package:area_app/pages/home_page.dart';
import 'package:area_app/pages/map_page.dart';
import 'package:area_app/pages/post_page.dart';
import 'package:area_app/pages/profile_page.dart';
import 'package:flutter/material.dart'; // this imports widgets

void main() {
  //runApp is a flutter function that inflates
  //the flutter built ui to the screen
  //this funciton takes a "widget" as an argument
  runApp(const MyApp());
}

// typing 'st' allows you to genreate this statless widget code
//statless widgets have no internal data
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeView());
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  //this line under createsa a page controller that i call in the pageview to set the intial page to the page in position one in the array
  PageController pageController = PageController(initialPage: 1);
  get onPressed => null;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // this is the app bar and will render above the body wich contains the page view
          backgroundColor: Colors.blue,
          elevation: 0,
          title: const Text(
            "test app",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            // ignore: prefer_const_constructors
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PostPage()));
                },
                icon: Icon(Icons.add_box_outlined)),
            // ignore: prefer_const_constructors
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChatPage()));
                },
                icon: Icon(Icons.chat_bubble_outline))
          ],
        ),
        body: PageView(
            //page view allows widgets to be rendered in the scaffold
            controller: pageController,
            children: const [
              //these are the pages within the page view byu default it scrolls horizzontly
              MapPage(),
              HomePage(),
              ProfilePage()
            ]),
      ),
    );
  }
}





//login screen widget
