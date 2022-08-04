import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

double? cLat = 53.390;
double? cLong = -6.293;
String code = "";
Set<Marker> list = {};
BitmapDescriptor? mapMarkImg;

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(53.3346, -6.2733),
    zoom: 15.4746,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //waits for stream to have data in it befor building the widget
      future: getCountry(cLong, cLat),
      builder: (context, snapshot) {
        return Scaffold(body: getBody(list));

        //returns the map
      },
    );
  }

  Widget getBody(Set<Marker> list) {
    return GoogleMap(
      //this gets the long and lat of the camera position and then returns a country code corisponding to that
      onCameraMove: (object) => {
        setState(() {
          cLat = object.target.latitude;
          cLong = object.target.longitude;
        })
      },
      markers: list,
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
Future getCountry(double? long, double? lat) async {
  double lat1;
  double long1;
  lat1 = lat!;
  long1 = long!;
  mapMarkImg = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(), 'assets/images/marker.png');
  //code taken from geocoding pub dev page
  List<Placemark> placemarks = await placemarkFromCoordinates(lat1, long1);
  //get first entry in the list of placemarkers
  Placemark place = placemarks[0];
  if (code != place.isoCountryCode!) {
    code = place.isoCountryCode!;
    //get response
    var postCodesResponse = await http.get(Uri.parse(
        'https://data.opendatasoft.com/api/records/1.0/search/?dataset=geonames-postal-code%40public&q=${code}&rows=139&facet=country_code&facet=admin_name1&facet=admin_code1&facet=admin_name2'));

    final postCodesJson = jsonDecode(postCodesResponse.body.toString());
    //print(postCodesJson["records"][0]["datasetid"]);
    for (var i in postCodesJson['records']) {
      Marker marker = Marker(
          markerId: MarkerId(i["fields"]["postal_code"].toString()),
          position: LatLng(i["fields"]["latitude"] as double,
              i["fields"]["longitude"] as double),
          icon: mapMarkImg!);

      list.add(marker);
      print(list.length);
    }
  }
}
