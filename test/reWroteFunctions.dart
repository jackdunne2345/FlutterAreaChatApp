import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//firebase imports

Future<String> getPostCode(Position position) async {
  Position pos = await position;
  List<double> distance = [];
  List<String> postcode = [];

  List<Placemark> placemarks =
      await placemarkFromCoordinates(pos.latitude, pos.longitude);
  //get first entry in the list of placemarkers
  Placemark place = placemarks[0];
  var postCodesResponse = await http.get(Uri.parse(
      'https://data.opendatasoft.com/api/records/1.0/search/?dataset=geonames-postal-code%40public&q=${place.isoCountryCode}&rows=139&facet=country_code&facet=admin_name1&facet=admin_code1&facet=admin_name2'));
  final postCodesJson = jsonDecode(postCodesResponse.body.toString());
  for (var i in postCodesJson['records']) {
    distance.add(Geolocator.distanceBetween(pos.latitude, pos.longitude,
        i["fields"]["latitude"] as double, i["fields"]["longitude"] as double));
    postcode.add(i["fields"]["postal_code"].toString());
  }
  var shortDistance = distance.reduce(min);
  var index = distance.indexOf(shortDistance);
  return postcode.elementAt(index);
}

Future<Position> determinePosition() async {
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
