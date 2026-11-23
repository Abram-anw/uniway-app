// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_university_services/main.dart';

void main() {
  testWidgets('renders the onboarding screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'uniway_onboarding_complete': false,
    });
    await tester.pumpWidget(const UniwayApp());
    await tester.pumpAndSettle();

    expect(find.text('UNIWAY'), findsOneWidget);
    expect(find.text('التالي'), findsOneWidget);
  });

  testWidgets('skipping onboarding opens login and persists the choice',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'uniway_onboarding_complete': false,
    });
    await tester.pumpWidget(const UniwayApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('تخطي'));
    await tester.pumpAndSettle();

    expect(find.text('تسجيل الدخول'), findsWidgets);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('uniway_onboarding_complete'), isTrue);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(const UniwayApp());
    await tester.pumpAndSettle();
    expect(find.text('تسجيل الدخول'), findsWidgets);
  });
}
