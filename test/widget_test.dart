import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:simpleiawriter/repos/purchase.repository.dart';
import 'package:simpleiawriter/repos/api.repository.dart';
import 'package:simpleiawriter/repos/auth.repository.dart';
import 'package:simpleiawriter/repos/datastore.repository.dart';

import 'package:simpleiawriter/main.dart';

// Mock class.
class MockAppRep extends Mock implements AmplifyAppRepository {}

// Mock class.
class MockDataRep extends Mock implements AmplifyDataStoreRepository {}

// Mock class.
class MockAuthRep extends Mock implements AmplifyAuthRepository {}

// Mock class.
class MockInAppPurchaseRep extends Mock implements InAppPurchaseRepository {}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App(
      apiRepository: MockAppRep(),
      dataStoreRepository: MockDataRep(),
      authRepository: MockAuthRep(),
      inAppPurchaseRepository: MockInAppPurchaseRep(),
    ));

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.login));
    await tester.pump();
  });
}
