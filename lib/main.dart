// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:math';
import 'package:area_app/providers/image_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:area_app/pages/home_page.dart';
import 'package:area_app/pages/map_page.dart';
import 'package:provider/provider.dart';
import 'providers/marker_provider.dart';
import 'package:area_app/pages/profile_page.dart';
import 'package:flutter/material.dart'; // this imports widgets
import 'package:flutter_login/flutter_login.dart'; //login package
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//firebase imports

import 'package:firebase_core/firebase_core.dart';

import 'firebase.dart';
import 'firebase_options.dart';

//icon pacages

AuthUser signedInAuthUser = AuthUser();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    print("ERROR FIRBASE" + e.message!);
  }

  signedInAuthUser = AuthUser();
  await getPostCode();
  //runApp is a flutter function that inflates
  //the flutter built ui to the screen
  //this funciton takes a "widget" as an argument
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => imgChange()),
      ChangeNotifierProvider(create: (_) => MarkerProvier())
    ],
    child: MyApp(),
  ));
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
  const HomeView({Key? key}) : super(key: key);
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
//current user

  //this line under createsa a page controller that i call in the pageview to set the intial page to the page in position one in the array
  PageController pageController = PageController(initialPage: 1);

  get onPressed => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          key: const Key("app bar"),
          // this is the app bar and will render above the body wich contains the page view
          backgroundColor: Colors.blue,
          elevation: 0,
          title: const Text(
            key: Key("text"),
            "Area App",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                key: const Key("iconbutton"),
                onPressed: () {
                  AuthWithGoogle().signOut();
                },
                icon: const Text(key: Key("text"), "log out")),

            // ignore: prefer_const_constructors
          ]),
      body: //HomePage(pCode: pCode)
          PageView(
              key: const Key("the swiper page view"),
              pageSnapping: true,
              //page view allows widgets to be rendered in this widgets scaffold in a scrollable view
              controller: pageController,
              children: [
            //these are the pages within the page view byu default it scrolls horizzontly
            ProfilePage(
              key: const Key("profile view"),
              uid: signedInAuthUser.uid,
            ),
            HomePage(
                key: const Key("home view"), pCode: signedInAuthUser.pcode),
            const MapPage(
              key: Key("map page"),
            )
          ]),
    );
  }
}

Future<void> updatePosition() async {
  Position position = await _determinePosition();

  signedInAuthUser.longitude = position.longitude;
  signedInAuthUser.latitude = position.latitude;
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
  Future<String?> authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return await AuthWithGoogle().logInEmail(data.name, data.password);
  }

  Future<String?> signupUser(SignupData data) async {
    debugPrint('Signup Email: ${data.name}, Password: ${data.password}');
    Map<String, String> userName = data.additionalSignupData!;

    return await AuthWithGoogle()
        .signUpEmail(data.name!, data.password!, userName['UserName']!);
  }

  Future<String?> _recoverPassword(String name) async {
    debugPrint('Name: $name');
    return await AuthWithGoogle().forgotPassword(name);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      key: const Key("login page"),
      title: 'Area App',
      logo: const AssetImage('assets/images/logo.png'),
      additionalSignupFields: [
        const UserFormField(keyName: "UserName", displayName: "Screen Name")
      ],
      onLogin: authUser,
      onSignup: signupUser,
      loginProviders: <LoginProvider>[
        LoginProvider(
            icon: FontAwesomeIcons.google,
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
Future getPostCode() async {
  await updatePosition();
  List<double> distance = [];
  List<String> postcode = [];

  List<Placemark> placemarks = await placemarkFromCoordinates(
      signedInAuthUser.latitude, signedInAuthUser.longitude);
  //get first entry in the list of placemarkers
  Placemark place = placemarks[0];
  var postCodesResponse = await http.get(Uri.parse(
      'https://data.opendatasoft.com/api/records/1.0/search/?dataset=geonames-postal-code%40public&q=${place.isoCountryCode}&rows=139&facet=country_code&facet=admin_name1&facet=admin_code1&facet=admin_name2'));
  final postCodesJson = jsonDecode(postCodesResponse.body.toString());
  for (var i in postCodesJson['records']) {
    distance.add(await Geolocator.distanceBetween(
        signedInAuthUser.latitude,
        signedInAuthUser.longitude,
        i["fields"]["latitude"] as double,
        i["fields"]["longitude"] as double));
    postcode.add(i["fields"]["postal_code"].toString());
  }
  var shortDistance = distance.reduce(min);
  var index = distance.indexOf(shortDistance);
  signedInAuthUser.pcode = place.postalCode!.substring(0, 3);
}
