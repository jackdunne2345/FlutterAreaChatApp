// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:area_app/pages/home_page.dart';
import 'package:area_app/pages/map_page.dart';
import 'package:area_app/pages/post_page.dart';
import 'package:area_app/pages/profile_page.dart';
import 'package:flutter/material.dart'; // this imports widgets
import 'package:flutter_login/flutter_login.dart'; //login package
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//firebase imports
import 'firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    return MaterialApp(home: LoginScreen());
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _HomeViewState extends State<HomeView> {
  var longitude = "";
  var latitude = "";
  var countryCode = "";
//current postion

//current user
  User? user = auth.currentUser;

  //this line under createsa a page controller that i call in the pageview to set the intial page to the page in position one in the array
  PageController pageController = PageController(initialPage: 1);
  get onPressed => null;
  @override
  Widget build(BuildContext context) {
    _updatePosition();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // this is the app bar and will render above the body wich contains the page view
          backgroundColor: Colors.blue,
          elevation: 0,
          title: const Text(
            "Area App",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            // ignore: prefer_const_constructors
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PostPage(
                            latitude: 53.3346,
                            longitude: -6.2733,
                          )));
                },
                icon: Icon(Icons.add_box_outlined)),
            // ignore: prefer_const_constructors
          ],
        ),
        body: PageView(
            pageSnapping: true,
            //page view allows widgets to be rendered in the scaffold
            controller: pageController,
            children: [
              //these are the pages within the page view byu default it scrolls horizzontly
              MapPage(),
              const HomePage(),
              ProfilePage(
                uid: auth.currentUser!.uid,
              )
            ]),
      ),
    );
  }

  Future<void> _updatePosition() async {
    Position position = await _determinePosition();
    List pm =
        await placemarkFromCoordinates(position.latitude, position.latitude);
    setState(() {
      longitude = position.latitude.toString();
      latitude = position.latitude.toString();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

//login screen widget
// constent ussers atm

class LoginScreen extends StatelessWidget {
  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return logIn(data.name, data.password);
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Email: ${data.name}, Password: ${data.password}');
    return signUp(data.name!, data.password!);
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      //  if (!users.containsKey(name)) {
      // return 'User not exists';
      // }
      return "hi";
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Area App',
      logo: AssetImage('assets/images/logo.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeView(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
