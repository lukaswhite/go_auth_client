import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:go_auth_client/main.dart';
import 'package:go_auth_client/app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());
  });
}
