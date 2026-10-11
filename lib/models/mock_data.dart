import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HomeCategory {
  final String label, iconName, nav;
  final Color bg, color;
  final int count;
  const HomeCategory({required this.label, required this.iconName, required this.bg, required this.color, required this.count, required this.nav});
}

final List<HomeCategory> homeCategories = [
  HomeCategory(label: 'المقررات', iconName: 'book', bg: AppColors.blueLight, color: AppColors.blue, count: 6, nav: 'courses'),
  HomeCategory(label: 'الدرجات', iconName: 'star', bg: AppColors.successLight, color: AppColors.success, count: 7, nav: 'grades'),
  HomeCategory(label: 'المستندات', iconName: 'file', bg: AppColors.warningLight, color: AppColors.warning, count: 4, nav: 'documents'),
  HomeCategory(label: 'المحاضرات', iconName: 'library', bg: Color(0xFFEDE9FE), color: AppColors.purple, count: 12, nav: 'lectures'),
  HomeCategory(label: 'شئون\nالطلاب', iconName: 'shield', bg: Color(0xFFFFF1F2), color: Color(0xFFE11D48), count: 9, nav: 'student-affairs-portal'),
  HomeCategory(label: 'الإشعارات', iconName: 'bell', bg: Color(0xFFF0FDF4), color: Color(0xFF15803D), count: 3, nav: 'notifications'),
];

class OnboardSlide {
  final String badge, title, body;
  final Color badgeBg, badgeColor, bg, accent;
  const OnboardSlide({required this.badge, required this.title, required this.body, required this.badgeBg, required this.badgeColor, required this.bg, required this.accent});
}

final List<OnboardSlide> onboardSlides = [
  OnboardSlide(badge: 'مرحباً بك', title: 'كل إجراءاتك الجامعية\nفي مكان واحد', body: 'لا مزيد من التنقل بين المكاتب. الدليل الذكي يجمع كل خدمات الجامعة بخطوات واضحة ومستندات محددة.', badgeBg: AppColors.blueLight, badgeColor: AppColors.blue, bg: AppColors.white, accent: AppColors.blue),
  OnboardSlide(badge: 'تنبيهات ذكية', title: 'لا تفوّت أي موعد\nنهائي مهم', body: 'سجّل في تذكيرات المواعيد النهائية وستصلك إشعارات قبل الموعد بالأيام التي تختارها.', badgeBg: AppColors.warningLight, badgeColor: AppColors.warning, bg: Color(0xFFFFFDF5), accent: AppColors.warning),
  OnboardSlide(badge: 'مساعد ذكي', title: 'مساعدك الجامعي\nمتاح دائماً', body: 'اسأل عن أي إجراء وسيجيبك المساعد الذكي فوراً ويوجهك إلى القسم المختص في ثوانٍ.', badgeBg: AppColors.successLight, badgeColor: AppColors.success, bg: Color(0xFFF5FFFA), accent: AppColors.success),
];

class HomeDeadline {
  final String title, dept, date, urgency;
  final int daysLeft;
  const HomeDeadline({required this.title, required this.dept, required this.date, required this.daysLeft, required this.urgency});
}

final List<HomeDeadline> homeDeadlines = [
  HomeDeadline(title: 'آخر موعد للتظلم من درجات الاختبار النهائي', dept: 'مراقبة الامتحانات', date: 'السبت، 5 يناير 2025', daysLeft: 2, urgency: 'danger'),
  HomeDeadline(title: 'تسجيل مواد الفصل الدراسي القادم', dept: 'الشؤون الأكاديمية', date: 'الأحد، 12 يناير 2025', daysLeft: 9, urgency: 'warning'),
  HomeDeadline(title: 'طلب شهادة التخرج وكشف الدرجات', dept: 'شؤون الطلاب', date: 'الثلاثاء، 21 يناير 2025', daysLeft: 18, urgency: 'success'),
];

final List<String> assistantSuggestions = ['ما هي مستندات التأجيل؟', 'كيف أسجل مادة إضافية؟', 'موعد التسجيل للفصل القادم؟'];

class ChatMsg {
  final String role, text;
  const ChatMsg({required this.role, required this.text});
}

final List<ChatMsg> assistantInitialMessages = [
  ChatMsg(role: 'bot', text: 'أهلاً بك، أنا مساعد UNIWAY. كيف يمكنني مساعدتك اليوم؟'),
  ChatMsg(role: 'user', text: 'كيف أقدم اعتراضاً على درجة مادة؟'),
  ChatMsg(role: 'bot', text: 'بالتأكيد! إليك خطوات تقديم الاعتراض:\n\n1. توجه لمكتب مراقب الامتحانات خلال أسبوع من النتائج\n2. أحضر هويتك وكشف الدرجات\n3. اطلب استمارة الاعتراض (م.ا-7)\n4. ادفع رسوم المراجعة إن وجدت\n5. انتظر الرد خلال 7 أيام عمل\n\nهل تريد تفاصيل المستندات المطلوبة؟'),
];

class ReminderItem {
  final String title, dept, deadline, urgency;
  final int daysLeft;
  final bool subscribed;
  const ReminderItem({required this.title, required this.dept, required this.deadline, required this.daysLeft, required this.subscribed, required this.urgency});
}

final List<ReminderItem> allReminders = [
  ReminderItem(title: 'التظلم من درجات الاختبار النهائي', dept: 'مراقبة الامتحانات', deadline: '5 يناير 2025', daysLeft: 2, subscribed: true, urgency: 'danger'),
  ReminderItem(title: 'تسجيل مواد الفصل الدراسي القادم', dept: 'الشؤون الأكاديمية', deadline: '12 يناير 2025', daysLeft: 9, subscribed: true, urgency: 'warning'),
  ReminderItem(title: 'طلب شهادة التخرج', dept: 'شؤون الطلاب', deadline: '21 يناير 2025', daysLeft: 18, subscribed: true, urgency: 'success'),
  ReminderItem(title: 'إجراء الحذف والإضافة', dept: 'الشؤون الأكاديمية', deadline: '28 يناير 2025', daysLeft: 25, subscribed: false, urgency: 'success'),
  ReminderItem(title: 'سداد رسوم الفصل الدراسي', dept: 'الشؤون المالية', deadline: '1 فبراير 2025', daysLeft: 29, subscribed: false, urgency: 'success'),
];

class StudentCourse {
  final String code, name, dr, schedule;
  final String? grade;
  final double? gpa;
  final int credits;
  const StudentCourse({required this.code, required this.name, required this.dr, required this.credits, this.grade, this.gpa, required this.schedule});
}

final List<StudentCourse> mockCourses = [
  StudentCourse(code: 'CS401', name: 'هندسة البرمجيات', dr: 'د. محمد الغامدي', credits: 3, grade: 'A', gpa: 4.0, schedule: 'أحد · ثلاثاء 10–11:30'),
  StudentCourse(code: 'CS415', name: 'شبكات الحاسب المتقدمة', dr: 'د. سارة القحطاني', credits: 3, grade: 'B+', gpa: 3.5, schedule: 'اثنين · أربعاء 12–1:30'),
  StudentCourse(code: 'CS440', name: 'الذكاء الاصطناعي', dr: 'د. خالد العتيبي', credits: 3, grade: null, gpa: null, schedule: 'أحد · ثلاثاء · خميس 9–10'),
  StudentCourse(code: 'MATH301', name: 'الإحصاء والاحتمالات', dr: 'د. فاطمة البشري', credits: 2, grade: 'A-', gpa: 3.7, schedule: 'اثنين · أربعاء 8–9'),
  StudentCourse(code: 'CS450', name: 'أمن المعلومات', dr: 'د. يوسف الدوسري', credits: 3, grade: null, gpa: null, schedule: 'ثلاثاء · خميس 2–3:30'),
  StudentCourse(code: 'CS461', name: 'مشروع التخرج 1', dr: 'د. أحمد الزهراني', credits: 3, grade: null, gpa: null, schedule: 'خميس 4–6'),
];

class LectureCourse {
  final String code, name, doctor, latest;
  final int count;
  const LectureCourse({required this.code, required this.name, required this.doctor, required this.count, required this.latest});
}

final List<LectureCourse> studentLectureCourses = [
  LectureCourse(code: 'CS401', name: 'هندسة البرمجيات', doctor: 'د. محمد الغامدي', count: 3, latest: '06 أكتوبر 2026 – 10:30 ص'),
  LectureCourse(code: 'CS415', name: 'شبكات الحاسب المتقدمة', doctor: 'د. سارة القحطاني', count: 2, latest: '05 أكتوبر 2026 – 01:15 م'),
  LectureCourse(code: 'CS440', name: 'الذكاء الاصطناعي', doctor: 'د. خالد العتيبي', count: 2, latest: '04 أكتوبر 2026 – 09:00 ص'),
  LectureCourse(code: 'CS461', name: 'مشروع التخرج 1', doctor: 'د. أحمد الزهراني', count: 0, latest: 'لا توجد محاضرات'),
];

class DoctorCourse {
  final String code, name, section, schedule;
  final int students;
  final bool submitted;
  const DoctorCourse({required this.code, required this.name, required this.students, required this.section, required this.schedule, required this.submitted});
}

final List<DoctorCourse> docCourses = [
  DoctorCourse(code: 'CS401', name: 'هندسة البرمجيات', students: 42, section: 'شعبة 1', schedule: 'أحد · ثلاثاء 10–11:30', submitted: false),
  DoctorCourse(code: 'CS415', name: 'شبكات الحاسب المتقدمة', students: 38, section: 'شعبة 2', schedule: 'اثنين · أربعاء 12–1:30', submitted: true),
  DoctorCourse(code: 'CS440', name: 'الذكاء الاصطناعي', students: 35, section: 'شعبة 1', schedule: 'أحد · ثلاثاء · خميس 9–10', submitted: false),
];

class RequestItem {
  final String name, type, course, date, status;
  final bool urgent;
  const RequestItem({required this.name, required this.type, required this.course, required this.date, required this.status, required this.urgent});
}

final List<RequestItem> mockRequests = [
  RequestItem(name: 'أحمد العمري', type: 'تظلم على درجة', course: 'هندسة البرمجيات', date: '5 يناير 2025', status: 'pending', urgent: true),
  RequestItem(name: 'نورة السبيعي', type: 'طلب وثيقة', course: 'كشف درجات رسمي', date: '4 يناير 2025', status: 'pending', urgent: false),
  RequestItem(name: 'خالد المطيري', type: 'انسحاب من مقرر', course: 'الذكاء الاصطناعي', date: '3 يناير 2025', status: 'approved', urgent: false),
  RequestItem(name: 'سارة الزهراني', type: 'طلب إجازة', course: 'إجازة طارئة', date: '2 يناير 2025', status: 'rejected', urgent: false),
];
