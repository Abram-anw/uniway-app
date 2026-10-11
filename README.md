# UNIWAY — دليل الخدمات الجامعية الذكي (نسخة Flutter)

تحويل كامل لمشروع React/TypeScript الأصلي إلى تطبيق **Flutter/Dart** أصلي، مقسّم إلى ملفات متعددة حسب الدور والمسؤولية.

## التشغيل

```bash
flutter pub get
flutter run
```

يتطلب Flutter SDK 3.3 أو أحدث (انظر `pubspec.yaml`).

## هيكل المشروع

```text
lib/
  main.dart                 نقطة البداية (MaterialApp + RTL)
  app_root.dart             آلة التنقل بين كل الشاشات
  theme/
    app_colors.dart         لوحة الألوان
    app_icon.dart           رسم الأيقونات
    app_icon_paths.dart     مسارات SVG للأيقونات
  models/
    procedure.dart          نموذج الإجراءات الجامعية
    mock_data.dart          البيانات التجريبية
    student_request.dart    أنواع طلبات شؤون الطلاب
    floor_rooms.dart        بيانات مخطط المبنى
  widgets/
    common.dart             مكونات مشتركة
    bottom_nav.dart         شريط التنقل السفلي
  screens/
    auth/                   تسجيل الدخول والتعريف بالتطبيق
    student/                شاشات الطالب
    high_school/            مسار تقديم طلاب الثانوية
    doctor/                 شاشات الدكتور
    student_affairs/        شاشات شؤون الطلاب
    admin/                  شاشات الإدارة
```

## ملاحظات على التحويل

* **البيانات:** البيانات التجريبية مستخرجة من الكود الأصلي للمشروع.
* **الأيقونات:** تُرسم مسارات SVG باستخدام حزمة `path_drawing`.
* **التنقل:** يتولى `app_root.dart` إدارة التنقل بين الشاشات.
* **خريطة المبنى:** تستخدم شبكة مبسطة للغرف مع بيانات الغرف والإحداثيات.
* **إدارة متطلبات الطلبات:** نسخة مبسطة للعرض والحفظ.
* يعتمد المشروع على حزمتَي `google_fonts` و`path_drawing` للخطوط والأيقونات.

## uniway-app

مشروع UNIWAY لإدارة الخدمات الجامعية باستخدام Flutter.
