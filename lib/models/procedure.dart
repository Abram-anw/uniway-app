import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class Office {
  final String name, building, floor, roomId;
  const Office({required this.name, required this.building, required this.floor, required this.roomId});
}

class Deadline {
  final String label, date, urgency;
  final int daysLeft;
  const Deadline({required this.label, required this.date, required this.daysLeft, required this.urgency});
}

class Procedure {
  final int id;
  final String title, dept, tag, duration, lastUpdated;
  final Color deptColor;
  final Deadline? deadline;
  final List<String> steps, documents;
  final Office office;
  const Procedure({
    required this.id, required this.title, required this.dept, required this.deptColor,
    required this.tag, required this.duration, this.deadline, required this.steps,
    required this.documents, required this.office, required this.lastUpdated,
  });
}

final List<Procedure> allProcedures = [
  Procedure(
    id: 1, title: 'الاعتراض على درجة الاختبار النهائي', dept: 'مراقبة الامتحانات',
    deptColor: AppColors.warning, tag: 'عاجل', duration: '7 أيام عمل',
    deadline: Deadline(label: 'آخر موعد للتقديم', date: 'السبت، 5 يناير 2025', daysLeft: 2, urgency: 'danger'),
    steps: ['تحقق من النتائج عبر البوابة الإلكترونية', 'توجه إلى مكتب مراقبة الامتحانات في المبنى الرئيسي', 'اطلب نموذج الاعتراض (نموذج م.ا-7)', 'أكمل النموذج وأرفق المستندات المطلوبة', 'سلّم الطلب واحتفظ بنسخة مختومة', 'تابع النتيجة خلال 7 أيام عبر البوابة'],
    documents: ['الهوية الجامعية سارية المفعول', 'كشف الدرجات الرسمي', 'نموذج الاعتراض م.ا-7', 'إيصال رسوم المراجعة (25 ريال)'],
    office: Office(name: 'مكتب مراقبة الامتحانات', building: 'المبنى الإداري الرئيسي', floor: 'الدور الأول', roomId: '102'), lastUpdated: 'آخر تحديث: 1 ديسمبر 2024',
  ),
  Procedure(
    id: 2, title: 'طلب تأجيل الاختبار', dept: 'مراقبة الامتحانات',
    deptColor: AppColors.warning, tag: 'شائع', duration: '3-5 أيام عمل',
    deadline: Deadline(label: 'التقديم قبل الاختبار بـ', date: '48 ساعة على الأقل', daysLeft: 9, urgency: 'warning'),
    steps: ['تأكد من توافر سبب مقبول', 'جهّز المستندات الداعمة', 'قدّم الطلب إلكترونياً أو حضورياً', 'أرفق جميع الوثائق المطلوبة', 'انتظر موافقة مراقب الامتحانات'],
    documents: ['الهوية الجامعية', 'التقرير الطبي من مستشفى معتمد', 'نموذج طلب التأجيل'],
    office: Office(name: 'مكتب مراقبة الامتحانات', building: 'المبنى الإداري الرئيسي', floor: 'الدور الأول', roomId: '102'), lastUpdated: 'آخر تحديث: 15 نوفمبر 2024',
  ),
  Procedure(
    id: 3, title: 'طلب كشف الدرجات الرسمي', dept: 'شؤون الطلاب',
    deptColor: AppColors.success, tag: '', duration: 'فوري',
    deadline: null,
    steps: ['سجّل دخولك إلى بوابة الطالب', 'اختر "الخدمات الأكاديمية"', 'حدد نوع الوثيقة', 'اختر اللغة والغرض', 'ادفع الرسوم واستلم الوثيقة'],
    documents: ['الهوية الجامعية', 'رسوم الطباعة (10 ريال)'],
    office: Office(name: 'مكتب شؤون الطلاب', building: 'مبنى الطلاب', floor: 'الدور الأرضي', roomId: 'G3'), lastUpdated: 'آخر تحديث: 1 يناير 2025',
  ),
  Procedure(
    id: 4, title: 'تسجيل المواد الدراسية', dept: 'الشؤون الأكاديمية',
    deptColor: AppColors.blue, tag: 'شائع', duration: 'فوري',
    deadline: Deadline(label: 'نافذة التسجيل تنتهي في', date: 'الأحد، 12 يناير 2025', daysLeft: 9, urgency: 'warning'),
    steps: ['راجع خطتك مع مرشدك الأكاديمي', 'سجّل دخولك لنظام التسجيل', 'ابحث عن المواد وتحقق من المقاعد', 'أضف المواد لسلة التسجيل', 'أكّد التسجيل النهائي'],
    documents: ['لا توجد مستندات ورقية', 'تسوية المستحقات المالية مسبقاً'],
    office: Office(name: 'مكتب الشؤون الأكاديمية', building: 'مبنى الإدارة الأكاديمية', floor: 'الدور الثاني', roomId: '210'), lastUpdated: 'آخر تحديث: 20 ديسمبر 2024',
  ),
  Procedure(
    id: 5, title: 'إجراء الحذف والإضافة', dept: 'الشؤون الأكاديمية',
    deptColor: AppColors.blue, tag: '', duration: '1-3 أيام',
    deadline: Deadline(label: 'نافذة الحذف والإضافة تغلق في', date: 'الثلاثاء، 14 يناير 2025', daysLeft: 11, urgency: 'warning'),
    steps: ['تأكد أن التعديل لا يتعارض مع الخطة', 'سجّل دخولك لنظام التسجيل', 'احذف أو أضف المادة المطلوبة', 'راجع مرشدك عند التعارض', 'أكّد التعديل قبل إغلاق النافذة'],
    documents: ['لا توجد مستندات في الحالة العادية', 'خطاب المرشد الأكاديمي للاستثناء'],
    office: Office(name: 'مكتب الشؤون الأكاديمية', building: 'مبنى الإدارة الأكاديمية', floor: 'الدور الثاني', roomId: '210'), lastUpdated: 'آخر تحديث: 5 يناير 2025',
  ),
  Procedure(
    id: 6, title: 'طلب شهادة التخرج', dept: 'شؤون الطلاب',
    deptColor: AppColors.success, tag: '', duration: '14 يوم عمل',
    deadline: null,
    steps: ['تأكد من اجتياز جميع متطلبات التخرج', 'قدّم الطلب عبر البوابة الأكاديمية', 'ادفع رسوم الشهادة', 'انتظر مراجعة السجلات', 'استلم الشهادة بعد الإشعار'],
    documents: ['الهوية الوطنية أو الإقامة', 'الهوية الجامعية', 'صورتان شخصيتان', 'إيصال رسوم الشهادة (150 ريال)'],
    office: Office(name: 'مكتب التسجيل وشؤون الطلاب', building: 'مبنى الطلاب', floor: 'الدور الأول', roomId: '115'), lastUpdated: 'آخر تحديث: 10 ديسمبر 2024',
  ),
  Procedure(
    id: 7, title: 'تغيير التخصص', dept: 'الإرشاد الأكاديمي',
    deptColor: AppColors.purple, tag: '', duration: '21 يوم عمل',
    deadline: null,
    steps: ['راجع متطلبات التخصص الجديد', 'احصل على موافقة القسمين', 'قدّم الطلب الرسمي', 'أرفق كشف الدرجات وخطابات الموافقة', 'انتظر دراسة مجلس الكلية', 'استلم إشعار القبول أو الرفض'],
    documents: ['الهوية الجامعية', 'كشف الدرجات الكامل', 'خطاب موافقة القسم الحالي', 'خطاب قبول القسم الجديد', 'نموذج طلب تغيير التخصص'],
    office: Office(name: 'مكتب الإرشاد الأكاديمي', building: 'مبنى الكلية الرئيسي', floor: 'الدور الثاني', roomId: '215'), lastUpdated: 'آخر تحديث: 1 نوفمبر 2024',
  ),
  Procedure(
    id: 8, title: 'الانسحاب من الفصل الدراسي', dept: 'الشؤون الأكاديمية',
    deptColor: AppColors.blue, tag: '', duration: '7 أيام',
    deadline: null,
    steps: ['تأكد أن الانسحاب لا يؤثر على الحد الأدنى', 'استشر مرشدك الأكاديمي', 'قدّم الطلب الرسمي', 'احصل على تواقيع الموافقة'],
    documents: ['الهوية الجامعية', 'نموذج طلب الانسحاب', 'خطاب المرشد الأكاديمي'],
    office: Office(name: 'مكتب الشؤون الأكاديمية', building: 'مبنى الإدارة الأكاديمية', floor: 'الدور الثاني', roomId: '210'), lastUpdated: 'آخر تحديث: 15 أكتوبر 2024',
  ),
  Procedure(
    id: 9, title: 'استعارة كتاب من المكتبة', dept: 'المكتبة',
    deptColor: Color(0xFFE11D48), tag: '', duration: 'فوري',
    deadline: null,
    steps: ['ابحث في فهرس المكتبة الإلكتروني', 'لاحظ رقم التصنيف وموقع الكتاب', 'استخرج الكتاب من القسم', 'قدّم الكتاب وهويتك للموظف'],
    documents: ['الهوية الجامعية سارية المفعول'],
    office: Office(name: 'مكتبة الجامعة الرئيسية', building: 'مبنى المكتبة', floor: 'الدور الأول', roomId: 'L1'), lastUpdated: 'آخر تحديث: 1 يناير 2025',
  ),
  Procedure(
    id: 10, title: 'طلب الدراسة المستقلة', dept: 'الإرشاد الأكاديمي',
    deptColor: AppColors.purple, tag: '', duration: '14 يوم عمل',
    deadline: null,
    steps: ['تواصل مع الأستاذ المشرف', 'حدد خطة الدراسة والمخرجات', 'قدّم الطلب الرسمي', 'أرفق الخطة الموقّعة', 'انتظر اعتماد مجلس القسم'],
    documents: ['الهوية الجامعية', 'خطة الدراسة المعتمدة', 'نموذج طلب الدراسة المستقلة'],
    office: Office(name: 'مكتب الإرشاد الأكاديمي', building: 'مبنى الكلية الرئيسي', floor: 'الدور الثاني', roomId: '215'), lastUpdated: 'آخر تحديث: 5 ديسمبر 2024',
  ),
];
