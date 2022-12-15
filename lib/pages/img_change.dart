import 'package:flutter/material.dart';

class imgChange with ChangeNotifier {
  String _bio = "";
  String _pic1 = "";
  String _pic2 = "";
  String _pic3 = "";
  String _pic4 = "";
  String _pic5 = "";
  String _pic6 = "";
  String _picp = "";
  String get pic1 => _pic1;
  String get pic2 => _pic2;
  String get pic3 => _pic3;
  String get pic4 => _pic4;
  String get pic5 => _pic5;
  String get pic6 => _pic6;
  String get pp => _picp;
  String get bio => _bio;

  set setBio(String value) {
    _bio = value;
  }

  set setPP(String value) {
    _picp = value;
    notifyListeners();
  }

  set setPic1(String value) {
    _pic1 = value;
    notifyListeners();
  }

  set setPic2(String value) {
    _pic2 = value;
    notifyListeners();
  }

  set setPic3(String value) {
    _pic3 = value;
    notifyListeners();
  }

  set setPic4(String value) {
    _pic4 = value;
    notifyListeners();
  }

  set setPic5(String value) {
    _pic5 = value;
    notifyListeners();
  }

  set setPic6(String value) {
    _pic6 = value;
    notifyListeners();
  }
}
