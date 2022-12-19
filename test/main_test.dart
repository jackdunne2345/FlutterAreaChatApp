import 'dart:ui';

import 'package:area_app/firebase.dart';
import 'package:area_app/main.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:math';
import 'package:area_app/pages/image_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:area_app/pages/home_page.dart';
import 'package:area_app/pages/map_page.dart';
import 'package:provider/provider.dart';

import 'package:area_app/pages/profile_page.dart';
import 'package:flutter/material.dart'; // this imports widgets
import 'package:flutter_login/flutter_login.dart'; //login package
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//firebase imports

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_test/flutter_test.dart';

void main() async {
  test('testing the generation of the post code', () async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    signedInAuthUser.longitude = 53.3347;
    signedInAuthUser.latitude = -6.3269;
    await getPostCode();
    var pcode = signedInAuthUser.pcode;

    expect(pcode, "D12");
  });
}
