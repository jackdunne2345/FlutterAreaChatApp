import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerProvier with ChangeNotifier {
  late BuildContext context;
  get getContext => this.context;

  set setContext(context) => this.context = context;
}
