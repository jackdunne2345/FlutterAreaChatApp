import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:math';

Duration get loginTime => Duration(milliseconds: 2250);
Future<String?> logIn(String name, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: name, password: password);
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  } on FirebaseAuthException catch (e) {
    return Future.delayed(loginTime).then((_) {
      return e.message;
    });
  }
}

Future<String?> signUp(String name, String password) async {
  try {
    UserCredential create = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: name, password: password);
    User user = create.user!;
    //set user data to default data when account is made
    String defBio = "Hi! I'm new :)";
    giveUserData(defBio, user.uid);

    return Future.delayed(loginTime).then((_) async {
      //this null retunr means there is no errors and will laucnh app
      return null;
    });
  } on FirebaseAuthException catch (e) {
    return Future.delayed(loginTime).then((_) async {
      //this return means there is an error and th error will display
      return e.message;
    });
  }
}

//this object a userData object referning to the "userCollection" colelction on my firestore

final CollectionReference userData =
    FirebaseFirestore.instance.collection('userCollection');

final CollectionReference postData =
    FirebaseFirestore.instance.collection('posts');

Future giveUserData(String bio, String uid) async {
  return await userData.doc(uid).set({'bio': bio});
  //  .then((value) => print("Data added"))
  // .catchError((error) => print("Failed to add data: $error"));
}

Future givePostData(String postText, String? uid, String longitude,
    String latitude, String countryCode, String? email) async {
  return await postData.doc().set({
    'post_text': postText,
    'longitude': longitude,
    'latitude': latitude,
    'uid': uid,
    'email': email,
    'post_code': countryCode
  });
}

//get post code
// i calcualte what post code marker youa re clsoest to using geolocator package
Future<String> getPostCode(double long, double lat) async {
  List<double> distance = [];
  List<String> postcode = [];
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

  return postcode.elementAt(index);
}
