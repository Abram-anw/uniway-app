import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_university_services/screens/student/settings_support_screens.dart';

void main() {
  testWidgets('account data validates and saves contact details',
      (tester) async {
    String? savedEmail;
    String? savedPhone;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AccountDataScreen(
            onBack: () {},
            email: 'student@university.edu',
            phone: '0501234567',
            onSave: (email, phone) {
              savedEmail = email;
              savedPhone = phone;
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'invalid-email');
    await tester.tap(find.text('حفظ التغييرات'));
    await tester.pump();
    expect(find.text('أدخل بريدًا إلكترونيًا صحيحًا'), findsOneWidget);
    expect(savedEmail, isNull);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'new.student@university.edu',
    );
    await tester.enterText(find.byType(TextFormField).at(1), '0551234567');
    await tester.tap(find.text('حفظ التغييرات'));
    await tester.pump();

    expect(savedEmail, 'new.student@university.edu');
    expect(savedPhone, '0551234567');
    expect(
      find.text('تم تحديث بيانات التواصل في الجلسة الحالية.'),
      findsOneWidget,
    );
  });

  testWidgets('password screen validates entries and explains backend status',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ChangePasswordScreen(onBack: () {})),
      ),
    );

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'CurrentPass1');
    await tester.enterText(fields.at(1), 'short');
    await tester.enterText(fields.at(2), 'short');
    await tester.tap(find.text('تأكيد التغيير'));
    await tester.pump();
    expect(find.text('يجب أن تتكون من 8 أحرف على الأقل'), findsOneWidget);

    await tester.enterText(fields.at(1), 'NewPassword123');
    await tester.enterText(fields.at(2), 'NewPassword123');
    await tester.tap(find.text('تأكيد التغيير'));
    await tester.pump();
    expect(
      find.text(
          'البيانات مكتملة. يلزم ربط التطبيق بخدمة الجامعة لتحديث كلمة المرور فعليًا.'),
      findsOneWidget,
    );
  });

  testWidgets('about page opens privacy policy', (tester) async {
    var openedPrivacy = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AboutAppScreen(
            onBack: () {},
            onPrivacy: () => openedPrivacy = true,
            onSupport: () {},
          ),
        ),
      ),
    );

    await tester.tap(find.text('سياسة الخصوصية'));
    expect(openedPrivacy, isTrue);
  });

  testWidgets('privacy page displays its sections', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: PrivacyPolicyScreen(onBack: () {}))),
    );

    expect(find.text('البيانات التي نستخدمها'), findsOneWidget);
    expect(find.text('استخدام البيانات'), findsOneWidget);
    expect(find.text('حماية البيانات'), findsOneWidget);
    expect(find.text('التحكم ببياناتك'), findsOneWidget);
  });
}
