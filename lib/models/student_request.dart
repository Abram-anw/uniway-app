class RequestItem {
  final String id;
  final String labelAr;
  final String kind;
  final String? hintAr;
  final int maxFiles;
  final String? copiesNote;

  const RequestItem({
    required this.id,
    required this.labelAr,
    required this.kind,
    this.hintAr,
    this.maxFiles = 1,
    this.copiesNote,
  });
}

class StudentRequestType {
  final String id;
  final String titleAr;
  final String descriptionAr;
  final String iconName;
  final List<RequestItem> items;

  const StudentRequestType({
    required this.id,
    required this.titleAr,
    required this.descriptionAr,
    required this.iconName,
    required this.items,
  });

  Iterable<RequestItem> get uploadItems =>
      items.where((item) => item.kind == 'upload' || item.kind == 'payment_proof');
}

const bool mockMilitaryEducationPassed = true;

const List<StudentRequestType> studentRequestTypes = [
  StudentRequestType(
    id: 'military-enrollment',
    titleAr: 'طلب تجنيد',
    descriptionAr: 'للطلبة المستجدين',
    iconName: 'shield',
    items: [
      RequestItem(
        id: 'military-form',
        labelAr: 'استمارة 2 جند واستمارة 7 جند',
        kind: 'upload',
        maxFiles: 2,
      ),
      RequestItem(id: 'high-school-certificate', labelAr: 'صورة من شهادة الثانوية العامة', kind: 'upload'),
      RequestItem(id: 'national-id', labelAr: 'صورة من البطاقة الشخصية', kind: 'upload'),
      RequestItem(id: 'birth-certificate', labelAr: 'صورة من شهادة الميلاد', kind: 'upload'),
      RequestItem(id: 'personal-photo', labelAr: 'صورة شخصية 4×6', kind: 'upload'),
    ],
  ),
  StudentRequestType(
    id: 'status-certificate',
    titleAr: 'طلب بيان حالة',
    descriptionAr: 'المستندات والخطوات المطلوبة لتقديم هذا الطلب',
    iconName: 'file',
    items: [
      RequestItem(id: 'status-high-school-certificate', labelAr: 'صورة من شهادة الثانوية العامة', kind: 'upload'),
      RequestItem(
        id: 'status-fees',
        labelAr: 'صورة من دفع مصروفات بيان الحالة من على موقع UMS',
        kind: 'payment_proof',
      ),
    ],
  ),
  StudentRequestType(
    id: 'track-change',
    titleAr: 'طلب تعديل مسار',
    descriptionAr: 'المستندات والخطوات المطلوبة لتقديم هذا الطلب',
    iconName: 'layers',
    items: [
      RequestItem(
        id: 'track-form',
        labelAr: 'استمارة تعديل مسار من غرفة الـ IT',
        kind: 'upload',
        hintAr: 'ارفع صورة الاستمارة بعد تعبئتها وختمها',
      ),
      RequestItem(
        id: 'track-stamps',
        labelAr: 'ختم من المرشد الأكاديمي ورئيس القسم القادم منه والقادم إليه',
        kind: 'physical_step',
        hintAr: 'تُختم الاستمارة قبل رفع صورتها',
      ),
      RequestItem(
        id: 'track-fees',
        labelAr: 'صورة من دفع مصروفات طلب تعديل المسار من على موقع الـ UMS',
        kind: 'payment_proof',
      ),
    ],
  ),
  StudentRequestType(
    id: 'grade-appeal-request',
    titleAr: 'طلب تظلم',
    descriptionAr: 'المستندات والخطوات المطلوبة لتقديم هذا الطلب',
    iconName: 'clipboard',
    items: [
      RequestItem(id: 'appeal-form-withdraw', labelAr: 'سحب استمارة من غرفة الـ IT', kind: 'physical_step'),
      RequestItem(id: 'appeal-form-submit', labelAr: 'تسليمها لشئون الطلاب', kind: 'physical_step'),
    ],
  ),
  StudentRequestType(
    id: 'registration-proof',
    titleAr: 'طلب إثبات قيد',
    descriptionAr: 'المستندات والخطوات المطلوبة لتقديم هذا الطلب',
    iconName: 'idCard',
    items: [
      RequestItem(id: 'registration-form-withdraw', labelAr: 'سحب استمارة من الشئون', kind: 'physical_step'),
      RequestItem(id: 'registration-form-return', labelAr: 'تسليمها مرة أخرى للشئون', kind: 'physical_step'),
      RequestItem(
        id: 'registration-fees',
        labelAr: 'صورة من دفع مصروفات طلب إثبات قيد من على موقع الـ UMS',
        kind: 'payment_proof',
      ),
    ],
  ),
  StudentRequestType(
    id: 'success-certificate',
    titleAr: 'طلب بيان نجاح',
    descriptionAr: 'المستندات والخطوات المطلوبة لتقديم هذا الطلب',
    iconName: 'star',
    items: [
      RequestItem(
        id: 'success-fees',
        labelAr: 'صورة من دفع مصروفات طلب بيان النجاح من على موقع الـ UMS',
        kind: 'payment_proof',
      ),
      RequestItem(
        id: 'military-education',
        labelAr: 'اجتياز التربية العسكرية',
        kind: 'condition',
      ),
    ],
  ),
  StudentRequestType(
    id: 'metro-card',
    titleAr: 'طلب عمل كارنيه مترو',
    descriptionAr: 'المستندات والخطوات المطلوبة لتقديم هذا الطلب',
    iconName: 'metro',
    items: [
      RequestItem(id: 'metro-form', labelAr: 'سحب استمارة من المترو', kind: 'physical_step'),
      RequestItem(
        id: 'metro-fees',
        labelAr: 'صورة من دفع مصروفات طلب كارنيه من على موقع الـ UMS',
        kind: 'payment_proof',
      ),
      RequestItem(
        id: 'metro-photos',
        labelAr: '3 صور شخصية 4×6',
        kind: 'upload',
        maxFiles: 3,
        copiesNote: 'سلّم النسخ الورقية حسب العدد المطلوب',
      ),
    ],
  ),
  StudentRequestType(
    id: 'graduation',
    titleAr: 'طلب شهادة تخرج',
    descriptionAr: 'المستندات والخطوات المطلوبة لتقديم هذا الطلب',
    iconName: 'award',
    items: [
      RequestItem(id: 'graduation-form', labelAr: 'سحب طلب شهادة التخرج من غرفة الـ IT', kind: 'physical_step'),
      RequestItem(
        id: 'graduation-fees',
        labelAr: 'صورة من دفع مصروفات طلب شهادة التخرج من على موقع الـ UMS',
        kind: 'payment_proof',
      ),
    ],
  ),
];
