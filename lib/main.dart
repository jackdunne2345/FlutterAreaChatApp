// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:area_app/pages/home_page.dart';
import 'package:area_app/pages/map_page.dart';

import 'package:area_app/pages/profile_page.dart';
import 'package:flutter/material.dart'; // this imports widgets
import 'package:flutter_login/flutter_login.dart'; //login package
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//firebase imports

import 'package:firebase_core/firebase_core.dart';
import 'firebase.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
//icon pacages
import 'package:fluttericon/brandico_icons.dart';

class pCodeObject {
  String pCode = "";

  String get getPcode {
    return pCode;
  }

  void set setPcode(String pCode) {
    this.pCode = pCode;
  }
}

pCodeObject pCodeObj = new pCodeObject();

var longitude = 0.0;
var latitude = 0.0;
var countryCode = "";
String pcode = "";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _updatePosition();
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
    return MaterialApp(home: AuthWithGoogle().handleAuthState());
  }
}

class HomeView extends StatefulWidget {
  User? Signed_In_User;

  HomeView({Key? key, required this.Signed_In_User}) : super(key: key);
  @override
  State<HomeView> createState() => _HomeViewState(Signed_In_User);
}

class _HomeViewState extends State<HomeView> {
//current user
  User? Signed_In_User;
  _HomeViewState(this.Signed_In_User);

  //this line under createsa a page controller that i call in the pageview to set the intial page to the page in position one in the array
  PageController pageController = PageController(initialPage: 1);

  get onPressed => null;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPostCode(longitude, latitude),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
                // this is the app bar and will render above the body wich contains the page view
                backgroundColor: Colors.blue,
                elevation: 0,
                title: const Text(
                  "Area App",
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MapPage(
                                  longitude: longitude,
                                  latitude: latitude,
                                )));
                      },
                      icon: Icon(Icons.map_outlined)),
                  IconButton(
                      onPressed: () {
                        AuthWithGoogle().signOut();
                      },
                      icon: Text("log out"))
                  // ignore: prefer_const_constructors
                ]),
            body: //HomePage(pCode: pCode)
                PageView(
                    pageSnapping: true,
                    //page view allows widgets to be rendered in this widgets scaffold in a scrollable view
                    controller: pageController,
                    children: [
                  //these are the pages within the page view byu default it scrolls horizzontly
                  ProfilePage(
                    uid: Signed_In_User!.uid,
                  ),
                  HomePage(pCode: pcode)
                ]),
          );
        });
  }
}

Future<void> _updatePosition() async {
  Position position = await _determinePosition();
  List pm =
      await placemarkFromCoordinates(position.latitude, position.latitude);

  longitude = position.longitude;
  latitude = position.latitude;
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
//login screen widget
// constent ussers atmF

class LoginScreen extends StatelessWidget {
  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return AuthWithGoogle().logInEmail(data.name, data.password);
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Email: ${data.name}, Password: ${data.password}');
    return AuthWithGoogle().signUpEmail(data.name!, data.password!);
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return AuthWithGoogle().forgotPassword(name);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Area App',
      logo: AssetImage('assets/images/logo.png'),
      additionalSignupFields: [
        const UserFormField(keyName: "User Name", displayName: "Screen Name")
      ],
      onLogin: _authUser,
      onSignup: _signupUser,
      loginProviders: <LoginProvider>[
        LoginProvider(
            icon: Icons.headphones,
            label: 'Google',
            callback: () async {
              await AuthWithGoogle().signIn();
            })
      ],
      onSubmitAnimationCompleted: () {
        return null;
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}

//get post code
// i calcualte what post code marker youa re clsoest to using geolocator package
Future<void> getPostCode(double long, double lat) async {
  List<double> distance = [];
  List<String> postcode = [];
  await _updatePosition();
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
  //get first entry in the list of placemarkers
  Placemark place = placemarks[0];
  var postCodesResponse = await http.get(Uri.parse(
      'https://data.opendatasoft.com/api/records/1.0/search/?dataset=geonames-postal-code%40public&q=${place.isoCountryCode}&rows=139&facet=country_code&facet=admin_name1&facet=admin_code1&facet=admin_name2'));
  final postCodesJson = jsonDecode(postCodesResponse.body.toString());
  for (var i in postCodesJson['records']) {
    distance.add(await Geolocator.distanceBetween(lat, long,
        i["fields"]["latitude"] as double, i["fields"]["longitude"] as double));
    postcode.add(i["fields"]["postal_code"].toString());
  }
  var shortDistance = distance.reduce(min);
  var index = distance.indexOf(shortDistance);
  pCodeObj.setPcode = postcode.elementAt(index);
  pcode = postcode.elementAt(index);
}
