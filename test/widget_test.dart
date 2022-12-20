import 'package:area_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'post_test.dart';

void main() {
  testWidgets("main view page", (WidgetTester tester) async {
    final appbar = find.byKey(ValueKey("app bar"));
    final text = find.byKey(ValueKey("text"));
    final iconbutton = find.byKey(ValueKey("iconbutton"));
    final pageview = find.byKey(ValueKey("the swiper page view"));
    final profile = find.byKey(ValueKey("profile view"));
    final home = find.byKey(ValueKey("home view"));
    final map = find.byKey(ValueKey("map page"));

    await tester.pumpWidget(MaterialApp(home: HomeView()));
    await tester.drag(pageview, Offset(500.0, 0.0));
  });
}
