import 'dart:ui';

import 'reWroteFunctions.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  test('testing the generation of the post code', () async {
    String result = "";
    foo() async {
      Position position = await determinePosition();
      result = await getPostCode(position);
    }

    await foo();

    expect(result, "D12");
  });
}
