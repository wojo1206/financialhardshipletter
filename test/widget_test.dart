import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simpleiawriter/bloc/api.repository.dart';
import 'package:simpleiawriter/bloc/auth.repository.dart';
import 'package:simpleiawriter/bloc/datastore.repository.dart';

import 'package:simpleiawriter/main.dart';

// Mock class.
class MockAppRep extends Mock implements AmplifyAppRepository {}

// Mock class.
class MockDataRep extends Mock implements AmplifyDataStoreRepository {}

// Mock class.
class MockAuthRep extends Mock implements AmplifyAuthRepository {}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App(
      apiRepository: MockAppRep(),
      dataStoreRepository: MockDataRep(),
      authRepository: MockAuthRep(),
    ));

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.login));
    await tester.pump();
  });
}
