/// أنواع طلبات شؤون الطلاب ومتطلبات كل طلب (مطابقة لـ studentRequestTypes في الكود الأصلي).
class RequestRequirement {
  final String name, hint, kind;
  final bool mandatory;
  final List<String>? options;
  const RequestRequirement({required this.name, required this.mandatory, required this.hint, required this.kind, this.options});
}

class StudentRequestType {
  final String id, name, description, iconName;
  final List<RequestRequirement> requirements;
  const StudentRequestType({required this.id, required this.name, required this.description, required this.iconName, required this.requirements});
}

final List<StudentRequestType> studentRequestTypes = [
  StudentRequestType(
    id: 'enrollment', name: 'إفادة قيد', description: 'إفادة رسمية تثبت قيدك بالجامعة', iconName: 'file',
    requirements: [
      RequestRequirement(name: 'صورة بطاقة الرقم القومي', mandatory: true, hint: 'صورة واضحة للوجهين', kind: 'file', options: null),
      RequestRequirement(name: 'إيصال سداد مصروفات الفصل الحالي', mandatory: true, hint: 'يجب أن يظهر رقم الطالب وتاريخ السداد', kind: 'file', options: null),
      RequestRequirement(name: 'جهة تقديم الإفادة', mandatory: true, hint: 'اكتب اسم الجهة الموجه إليها الإفادة', kind: 'text', options: null),
    ],
  ),
  StudentRequestType(
    id: 'transcript', name: 'كشف درجات رسمي', description: 'كشف معتمد بجميع المقررات والدرجات', iconName: 'star',
    requirements: [
      RequestRequirement(name: 'صورة بطاقة الرقم القومي', mandatory: true, hint: 'صورة واضحة للوجهين', kind: 'file', options: null),
      RequestRequirement(name: 'إيصال سداد رسوم الكشف', mandatory: true, hint: 'إيصال حديث وواضح', kind: 'file', options: null),
      RequestRequirement(name: 'صورة شخصية حديثة', mandatory: false, hint: 'خلفية بيضاء وبدون تعديلات', kind: 'file', options: null),
    ],
  ),
  StudentRequestType(
    id: 'graduation', name: 'طلب شهادة التخرج', description: 'إصدار شهادة التخرج الرسمية', iconName: 'award',
    requirements: [
      RequestRequirement(name: 'صورة بطاقة الرقم القومي', mandatory: true, hint: 'صورة واضحة للوجهين', kind: 'file', options: null),
      RequestRequirement(name: 'صورة شخصية حديثة بخلفية بيضاء', mandatory: true, hint: 'صورة رسمية حديثة', kind: 'file', options: null),
      RequestRequirement(name: 'إيصال سداد رسوم الشهادة', mandatory: true, hint: 'إيصال واضح باسم الطالب', kind: 'file', options: null),
      RequestRequirement(name: 'استمارة إخلاء الطرف', mandatory: true, hint: 'معتمدة من جميع الجهات', kind: 'file', options: null),
      RequestRequirement(name: 'شهادة إتمام التربية العسكرية', mandatory: true, hint: 'للطلاب المطلوب منهم أداؤها', kind: 'file', options: null),
      RequestRequirement(name: 'صورة شهادة الثانوية العامة', mandatory: true, hint: 'نسخة كاملة وواضحة', kind: 'file', options: null),
    ],
  ),
  StudentRequestType(
    id: 'suspend', name: 'إيقاف قيد', description: 'إيقاف الدراسة مؤقتًا وفق اللوائح', iconName: 'clock',
    requirements: [
      RequestRequirement(name: 'طلب إيقاف القيد مكتوب وموقّع', mandatory: true, hint: 'موضح به المدة والسبب', kind: 'file', options: null),
      RequestRequirement(name: 'صورة بطاقة الرقم القومي للطالب', mandatory: true, hint: 'صورة واضحة للوجهين', kind: 'file', options: null),
      RequestRequirement(name: 'صورة بطاقة ولي الأمر', mandatory: true, hint: 'صورة واضحة للوجهين', kind: 'file', options: null),
      RequestRequirement(name: 'موافقة ولي الأمر', mandatory: true, hint: 'موافقة مكتوبة وموقعة', kind: 'file', options: null),
      RequestRequirement(name: 'مستند يثبت سبب الإيقاف', mandatory: false, hint: 'تقرير طبي أو مستند رسمي داعم', kind: 'file', options: null),
    ],
  ),
  StudentRequestType(
    id: 'transfer', name: 'تحويل بين الأقسام', description: 'طلب الانتقال إلى قسم أكاديمي آخر', iconName: 'layers',
    requirements: [
      RequestRequirement(name: 'نموذج طلب التحويل', mandatory: true, hint: 'مكتمل البيانات وموقّع', kind: 'file', options: null),
      RequestRequirement(name: 'صورة بطاقة الرقم القومي', mandatory: true, hint: 'صورة واضحة للوجهين', kind: 'file', options: null),
      RequestRequirement(name: 'كشف درجات حديث', mandatory: true, hint: 'صادر خلال الفصل الحالي', kind: 'file', options: null),
      RequestRequirement(name: 'موافقة القسمين', mandatory: false, hint: 'موافقة القسم الحالي والقسم المطلوب', kind: 'file', options: null),
    ],
  ),
  StudentRequestType(
    id: 'replacement', name: 'بدل فاقد لبطاقة الجامعة', description: 'استخراج بطاقة جامعية بديلة', iconName: 'idCard',
    requirements: [
      RequestRequirement(name: 'صورة محضر إثبات الفقد', mandatory: true, hint: 'محضر رسمي واضح البيانات', kind: 'file', options: null),
      RequestRequirement(name: 'صورة بطاقة الرقم القومي', mandatory: true, hint: 'صورة واضحة للوجهين', kind: 'file', options: null),
      RequestRequirement(name: 'صورة شخصية حديثة', mandatory: true, hint: 'خلفية بيضاء', kind: 'file', options: null),
      RequestRequirement(name: 'إيصال سداد رسوم البدل', mandatory: true, hint: 'إيصال حديث باسم الطالب', kind: 'file', options: null),
    ],
  ),
  StudentRequestType(
    id: 'exam-excuse', name: 'إعذار عن امتحان', description: 'تقديم عذر رسمي عن غياب امتحان', iconName: 'alert',
    requirements: [
      RequestRequirement(name: 'تقرير طبي معتمد أو مستند العذر', mandatory: true, hint: 'صادر من جهة رسمية ومعتمدة', kind: 'file', options: null),
      RequestRequirement(name: 'صورة بطاقة الرقم القومي', mandatory: true, hint: 'صورة واضحة للوجهين', kind: 'file', options: null),
      RequestRequirement(name: 'المقرر المراد الإعذار عنه', mandatory: true, hint: 'اختر المقرر من مقرراتك المسجلة', kind: 'select', options: ['هندسة البرمجيات CS401', 'شبكات الحاسب CS415', 'الذكاء الاصطناعي CS440']),
      RequestRequirement(name: 'سبب الإعذار', mandatory: true, hint: 'اكتب سبب الغياب باختصار', kind: 'text', options: null),
    ],
  ),
  StudentRequestType(
    id: 'other', name: 'أخرى', description: 'طلب إداري غير مدرج في القائمة', iconName: 'plusCircle',
    requirements: [
      RequestRequirement(name: 'وصف الطلب', mandatory: true, hint: 'اشرح طلبك بوضوح وتفصيل', kind: 'text', options: null),
      RequestRequirement(name: 'مرفقات داعمة', mandatory: false, hint: 'أي مستندات تساعد في مراجعة الطلب', kind: 'file', options: null),
    ],
  ),
];
