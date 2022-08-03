import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:area_app/main.dart';
import 'package:geocoding/geocoding.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

double? cLat = 11.5760029;
double? cLong = 104.845914;

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.5760029, 104.845914),
    zoom: 15.4746,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //waits for stream to have data in it befor building the widget
      future: getCountry(cLong, cLat),
      builder: (context, snapshot) {
        return Scaffold(body: getBody()); //returns the map
      },
    );
  }

  Widget getBody() {
    return GoogleMap(
      //this gets the long and lat of the camera position and then returns a country code corisponding to that
      onCameraMove: (object) => {
        setState(() {
          cLat = object.target.latitude;
          cLong = object.target.longitude;
        })
      },
      mapType: MapType.normal,
      buildingsEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}

//get country code
Future<String?> getCountry(double? long, double? lat) async {
  double lat1;
  double long1;
  long1 = long as double;
  lat1 = lat as double;
  //code taken from geocoding pub dev page
  List<Placemark> placemarks = await placemarkFromCoordinates(lat1, long1);
  //get first entry in the list of placemarkers
  Placemark place = placemarks[0];
  // this will return country iso code
  print(place.isoCountryCode!);
  return place.isoCountryCode!;
}
