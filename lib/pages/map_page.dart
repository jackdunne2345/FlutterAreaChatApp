import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geocoding/geocoding.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(11.5760029, 104.845914),
    zoom: 15.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getCountry(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body:
                    getBody()); //this wont work atm but we gotta keep it fresh
            // print(snapshot.data.toString());
          } else {
            return Text('Loading...');
          }
        },
      ),
    );
  }

  Widget getBody() {
    return GoogleMap(
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
Future<String?> getCountry() async {
  //code taken from geocoding pub dev page
  List<Placemark> placemarks =
      await placemarkFromCoordinates(11.5760029, 104.845914);
  //get first entry in the list of placemarkers
  Placemark place = placemarks[0];
  // this will return country iso code

  return place.isoCountryCode;
}
