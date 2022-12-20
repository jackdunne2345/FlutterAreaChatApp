import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

LocationSettings locationSettings = const LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 100,
);

class UserProvider with ChangeNotifier {
  Position? pos;
  String pcode = "";
  void stream() {
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position!.latitude, position.longitude);
      Placemark place = placemarks[0];
      pcode = place.postalCode!.substring(0, 3);
    });
  }
}
