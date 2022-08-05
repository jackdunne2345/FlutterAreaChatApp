import 'dart:async';
import 'dart:convert';
import 'package:area_app/main.dart';
import 'package:area_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'home_page.dart';

class MapPage extends StatefulWidget {
  double longitude;
  double latitude;
  MapPage({Key? key, required this.longitude, required this.latitude})
      : super(key: key);
  @override
  _MapPageState createState() => _MapPageState(longitude, latitude);
}

double cLat = latitude;
double cLong = longitude;
String code = "";
Set<Marker> list = {};
BitmapDescriptor? mapMarkImg;

class _MapPageState extends State<MapPage> {
  double longitude;
  double latitude;
  _MapPageState(this.longitude, this.latitude);
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(cLat, cLong),
    zoom: 15.4746,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //waits for stream to have data in it befor building the widget
      future: getCountry(cLong, cLat, context),
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
      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}

//get country code
Future getCountry(double long, double lat, BuildContext context) async {
  double lat1;

  double long1;
  lat1 = lat;
  long1 = long;
  mapMarkImg = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(), 'assets/images/marker.png');
  //code taken from geocoding pub dev page
  List<Placemark> placemarks = await placemarkFromCoordinates(lat1, long1);
  //get first entry in the list of placemarkers
  Placemark place = placemarks[0];
  if (code != place.isoCountryCode) {
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
        icon: mapMarkImg!,
        infoWindow: InfoWindow(
          title: i["fields"]["postal_code"].toString(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => HomePage(
                  pCode: i["fields"]["postal_code"].toString(),
                ),
              ),
            );
            // Get.to(
            //   HomePage(
            //     pCode: i["fields"]["postal_code"].toString(),
            //   ),
            // );
          },
        ),
      );

      list.add(marker);
      print(list.length);
    }
  }
}
