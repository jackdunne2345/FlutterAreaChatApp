import 'dart:async';
import 'dart:convert';
import 'package:area_app/main.dart';
import 'package:area_app/pages/home_page.dart';
import 'package:area_app/providers/marker_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../providers/marker_provider.dart';

double cLat = SignedInAuthUser.latitude;
double cLong = SignedInAuthUser.longitude;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

BitmapDescriptor? mapMarkImg;

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> list = {};

  String code = "";
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(cLat, cLong),
    zoom: 15.4746,
  );

  @override
  Widget build(BuildContext context) {
    Provider.of<MarkerProvier>(context, listen: false).setContext = context;
    return FutureBuilder(
      //waits for stream to have data in it befor building the widget
      future: getCountry(cLong, cLat, context.watch<MarkerProvier>().context),
      builder: (context, snapshot) {
        return Scaffold(body: getBody());

        //returns the map
      },
    );
  }

//get country code
  Future<void> getCountry(double long, double lat, BuildContext context) async {
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
                MaterialPageRoute(
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

  Widget getBody() {
    return Stack(children: <Widget>[
      GoogleMap(
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
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          ].toSet()),
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: MemoryImage(kTransparentImage))),
        width: 10,
        height: double.infinity,
        alignment: Alignment.centerLeft,
      )
    ]);
  }
}
