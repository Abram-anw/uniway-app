import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';
import '../../widgets/common.dart';

class GradeAppeal {
  final String trackingNumber;
  final String courseName;
  final String courseCode;
  final String examType;
  final String currentGrade;
  final String reason;
  final String details;
  final String status;
  final String submittedAt;

  const GradeAppeal({
    required this.trackingNumber,
    required this.courseName,
    required this.courseCode,
    required this.examType,
    required this.currentGrade,
    required this.reason,
    required this.details,
    required this.status,
    required this.submittedAt,
  });
}

/// سجل الدرجات: المعدل التراكمي وقوائم المقررات لكل فصل.
class GradesScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  final List<GradeAppeal> appeals;
  final ValueChanged<GradeAppeal> onTrackAppeal;
  const GradesScreen(
      {super.key,
      required this.onNav,
      required this.appeals,
      required this.onTrackAppeal});

  @override
  Widget build(BuildContext context) {
    final graded = mockCourses.take(4).where((c) => c.grade != null).toList();
    final semesters = [
      {'name': 'الفصل الثاني 1446', 'gpa': '3.85'},
      {'name': 'الفصل الأول 1446', 'gpa': '4.05'},
    ];
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              color: AppColors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('سجل الدرجات',
                      style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(child: _stat('4.21', 'المعدل التراكمي')),
                    const SizedBox(width: 10),
                    Expanded(child: _stat('112', 'ساعة منجزة')),
                    const SizedBox(width: 10),
                    Expanded(child: _stat('7', 'المستوى')),
                  ]),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  ...semesters.map<Widget>((sem) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(sem['name']!,
                                  style: GoogleFonts.cairo(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.text)),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                    color: AppColors.blueLight,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text('المعدل: ${sem['gpa']}',
                                    style: GoogleFonts.cairo(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.blue)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border)),
                            child: Column(
                              children: List.generate(graded.length, (i) {
                                final c = graded[i];
                                final isA =
                                    c.grade != null && c.grade!.startsWith('A');
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () => onNav('grade-detail'),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(c.name,
                                                      style: GoogleFonts.cairo(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              AppColors.text)),
                                                  Text(
                                                      '${c.code} · ${c.credits} ساعات',
                                                      style: GoogleFonts.cairo(
                                                          fontSize: 11,
                                                          color: AppColors
                                                              .textMuted)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                  color: (isA
                                                          ? AppColors.success
                                                          : AppColors.blue)
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Text(c.grade ?? '',
                                                  style: GoogleFonts.cairo(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: isA
                                                          ? AppColors.success
                                                          : AppColors.blue)),
                                            ),
                                            const AppIcon('chevronLeft',
                                                size: 14,
                                                color: AppColors.textMuted),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (i < graded.length - 1)
                                      const Divider(
                                          height: 1,
                                          color: AppColors.border,
                                          indent: 16),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  _AppealsSection(
                    appeals: appeals,
                    onNew: () => onNav('appeal'),
                    onTrack: onTrackAppeal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String val, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14)),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(val,
              style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white)),
          Text(label,
              style: GoogleFonts.cairo(
                  fontSize: 10, color: Colors.white.withValues(alpha: 0.7))),
        ],
      ),
    );
  }
}

class _GradeItem {
  final String label;
  final double weight, earned;
  const _GradeItem(this.label, this.weight, this.earned);
}

const _gradeItems = [
  _GradeItem('حضور وأنشطة', 10, 9.5),
  _GradeItem('واجبات', 10, 8.0),
  _GradeItem('مشروع', 20, 18.0),
  _GradeItem('اختبار منتصف', 25, 22.5),
  _GradeItem('اختبار نهائي', 35, 31.0),
];

/// تفاصيل درجة مقرر واحد: تفصيل كل عنصر تقييم مع إمكانية طلب تظلم.
class GradeDetailScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  final VoidCallback onBack;
  const GradeDetailScreen(
      {super.key, required this.onNav, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final total = _gradeItems.fold(0.0, (s, i) => s + i.earned);
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(
              title: 'تفاصيل درجة المقرر',
              sub: 'هندسة البرمجيات · CS401',
              onBack: onBack,
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(12)),
                child: Text('A',
                    style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.success)),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: [
                        Text(total.toStringAsFixed(0),
                            style: GoogleFonts.cairo(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: AppColors.success)),
                        Text('المجموع الكلي من 100',
                            style: GoogleFonts.cairo(
                                fontSize: 12, color: AppColors.textMuted)),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                              value: total / 100,
                              minHeight: 8,
                              backgroundColor: AppColors.bg,
                              color: AppColors.success),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(_gradeItems.length, (i) {
                        final item = _gradeItems[i];
                        final ratio = item.earned / item.weight;
                        final good = ratio >= 0.9;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item.label,
                                          style: GoogleFonts.cairo(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.text)),
                                      Text(
                                          '${item.earned} / ${item.weight.toStringAsFixed(0)}',
                                          style: GoogleFonts.cairo(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: good
                                                  ? AppColors.success
                                                  : AppColors.blue)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                        value: ratio.clamp(0, 1),
                                        minHeight: 6,
                                        backgroundColor: AppColors.bg,
                                        color: good
                                            ? AppColors.success
                                            : AppColors.blue),
                                  ),
                                ],
                              ),
                            ),
                            if (i < _gradeItems.length - 1)
                              const Divider(height: 1, color: AppColors.border),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SecondaryButton(
                      label: 'تقديم طلب تظلم',
                      onPressed: () => onNav('appeal')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppealsSection extends StatelessWidget {
  final List<GradeAppeal> appeals;
  final VoidCallback onNew;
  final ValueChanged<GradeAppeal> onTrack;

  const _AppealsSection(
      {required this.appeals, required this.onNew, required this.onTrack});

  Color _statusColor(String status) {
    if (status == 'تم القبول') return AppColors.success;
    if (status == 'تم الرفض') return AppColors.danger;
    if (status == 'يحتاج إلى معلومات إضافية') return AppColors.warning;
    return AppColors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('التظلمات',
                  style: GoogleFonts.cairo(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.text)),
              TextButton.icon(
                onPressed: onNew,
                icon: const AppIcon('plus', size: 16, color: AppColors.blue),
                label: Text('تظلم جديد',
                    style: GoogleFonts.cairo(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue)),
              ),
            ],
          ),
          if (appeals.isEmpty)
            _emptyAppeals(onNew)
          else
            ...appeals.map((appeal) {
              final color = _statusColor(appeal.status);
              return InkWell(
                onTap: () => onTrack(appeal),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border)),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: AppColors.warningLight,
                            borderRadius: BorderRadius.circular(12)),
                        alignment: Alignment.center,
                        child: const AppIcon('file',
                            size: 19, color: AppColors.warning),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appeal.courseName,
                                style: GoogleFonts.cairo(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.text)),
                            Text(
                                '${appeal.trackingNumber} · ${appeal.submittedAt}',
                                style: GoogleFonts.cairo(
                                    fontSize: 10, color: AppColors.textMuted)),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(appeal.status,
                                  style: GoogleFonts.cairo(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: color)),
                            ),
                          ],
                        ),
                      ),
                      const AppIcon('chevronLeft',
                          size: 16, color: AppColors.textMuted),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _emptyAppeals(VoidCallback onNew) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          const AppIcon('file', size: 28, color: AppColors.textMuted),
          const SizedBox(height: 8),
          Text('لا توجد تظلمات سابقة',
              style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSub)),
          TextButton(
              onPressed: onNew,
              child: Text('تقديم أول تظلم',
                  style:
                      GoogleFonts.cairo(fontSize: 12, color: AppColors.blue))),
        ],
      ),
    );
  }
}

const _appealTypes = [
  'خطأ في رصد الدرجة',
  'عدم احتساب واجب',
  'خطأ في التصحيح',
  'درجة الحضور',
  'أخرى'
];

/// شاشة تقديم طلب تظلم على درجة.
class AppealScreen extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<GradeAppeal> onSubmitted;
  const AppealScreen(
      {super.key, required this.onBack, required this.onSubmitted});

  @override
  State<AppealScreen> createState() => _AppealScreenState();
}

class _AppealScreenState extends State<AppealScreen> {
  String _type = _appealTypes.first;
  String _examType = 'الاختبار النهائي';
  String _course = 'هندسة البرمجيات · CS401';
  String _grade = 'A (96)';
  String? _attachmentName;
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(
                title: 'تقديم تظلم جديد',
                sub: 'يمكنك التظلم على أي درجة مسجلة لديك',
                onBack: widget.onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  _fieldLabel('المقرر'),
                  DropdownButtonFormField<String>(
                    initialValue: _course,
                    items: const [
                      DropdownMenuItem(
                          value: 'هندسة البرمجيات · CS401',
                          child: Text('هندسة البرمجيات · CS401')),
                      DropdownMenuItem(
                          value: 'شبكات الحاسب المتقدمة · CS415',
                          child: Text('شبكات الحاسب المتقدمة · CS415')),
                      DropdownMenuItem(
                          value: 'الإحصاء والاحتمالات · MATH301',
                          child: Text('الإحصاء والاحتمالات · MATH301')),
                    ],
                    onChanged: (value) => setState(() => _course = value!),
                    decoration: _inputDecoration(),
                    style:
                        GoogleFonts.cairo(fontSize: 12, color: AppColors.text),
                  ),
                  const SizedBox(height: 12),
                  _fieldLabel('نوع الامتحان'),
                  _choiceRow([
                    'الاختبار النهائي',
                    'اختبار منتصف الفصل',
                    'أعمال السنة'
                  ]),
                  const SizedBox(height: 12),
                  _fieldLabel('الدرجة الحالية'),
                  _choiceRow(['A (96)', 'B+ (87)', 'A- (89)']),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('سبب التظلم',
                            style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.text)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: _appealTypes.map((t) {
                            final active = _type == t;
                            return InkWell(
                              onTap: () => setState(() => _type = t),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  color: active
                                      ? AppColors.blueLight
                                      : AppColors.bg,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: active
                                          ? AppColors.blue
                                          : AppColors.border,
                                      width: 1.5),
                                ),
                                child: Text(t,
                                    style: GoogleFonts.cairo(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: active
                                            ? AppColors.blue
                                            : AppColors.textSub)),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('تفاصيل إضافية',
                            style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.text)),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _detailsController,
                          maxLines: 4,
                          textAlign: TextAlign.right,
                          style: GoogleFonts.cairo(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'اشرح سبب طلب التظلم بالتفصيل...',
                            hintStyle: GoogleFonts.cairo(
                                fontSize: 12, color: AppColors.textMuted),
                            filled: true,
                            fillColor: AppColors.bg,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: AppColors.border)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const AppIcon('file', size: 18, color: AppColors.blue),
                      const SizedBox(width: 8),
                      Text('مرفق اختياري',
                          style: GoogleFonts.cairo(
                              fontSize: 12, color: AppColors.textSub)),
                      const Spacer(),
                      OutlinedButton(
                        onPressed: () async {
                          final result = await FilePicker.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                          );
                          if (result.isNotEmpty && mounted) {
                            setState(
                                () => _attachmentName = result.single.name);
                          }
                        },
                        child: Text('إضافة ملف',
                            style: GoogleFonts.cairo(
                                fontSize: 11, color: AppColors.blue)),
                      ),
                    ],
                  ),
                  if (_attachmentName != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('الملف المرفق: $_attachmentName',
                          style: GoogleFonts.cairo(
                              fontSize: 11, color: AppColors.success)),
                    ),
                  const SizedBox(height: 8),
                  PrimaryButton(
                    label: 'إرسال التظلم',
                    onPressed: () => widget.onSubmitted(_buildAppeal()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() => InputDecoration(
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      );

  Widget _fieldLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(label,
            style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.text)),
      );

  Widget _choiceRow(List<String> choices) => Wrap(
        spacing: 6,
        runSpacing: 6,
        children: choices.map((choice) {
          final active = (_examType == choice || _grade == choice);
          final isExamChoice =
              choices.length == 3 && choices.first == 'الاختبار النهائي';
          return InkWell(
            onTap: () => setState(() {
              if (isExamChoice) {
                _examType = choice;
              } else {
                _grade = choice;
              }
            }),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                  color: active ? AppColors.blueLight : AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: active ? AppColors.blue : AppColors.border)),
              child: Text(choice,
                  style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: active ? AppColors.blue : AppColors.textSub)),
            ),
          );
        }).toList(),
      );

  GradeAppeal _buildAppeal() {
    final parts = _course.split(' · ');
    return GradeAppeal(
      trackingNumber:
          'TZ-2026-${DateTime.now().millisecondsSinceEpoch % 10000}',
      courseName: parts.first,
      courseCode: parts.length > 1 ? parts.last : 'CS401',
      examType: _examType,
      currentGrade: _grade,
      reason: _type,
      details: _detailsController.text.trim().isEmpty
          ? 'لا توجد تفاصيل إضافية.'
          : _detailsController.text.trim(),
      status: 'قيد المراجعة',
      submittedAt: 'اليوم',
    );
  }
}

class AppealSuccessScreen extends StatelessWidget {
  final GradeAppeal appeal;
  final VoidCallback onTrack;
  final VoidCallback onBackToGrades;
  const AppealSuccessScreen(
      {super.key,
      required this.appeal,
      required this.onTrack,
      required this.onBackToGrades});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'تم إرسال التظلم', onBack: onBackToGrades),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 42, 24, 24),
                children: [
                  const Center(
                      child: Icon(Icons.check_circle,
                          size: 68, color: AppColors.success)),
                  const SizedBox(height: 16),
                  Center(
                      child: Text('تم إرسال طلب التظلم بنجاح',
                          style: GoogleFonts.cairo(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: AppColors.text))),
                  const SizedBox(height: 8),
                  Center(
                      child: Text(
                          'احتفظ برقم التتبع لمتابعة حالة طلبك من قسم التظلمات.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: AppColors.textSub,
                              height: 1.7))),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: AppColors.blueLight,
                        borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      children: [
                        Text('رقم التتبع',
                            style: GoogleFonts.cairo(
                                fontSize: 11, color: AppColors.textSub)),
                        const SizedBox(height: 4),
                        Text(appeal.trackingNumber,
                            style: GoogleFonts.cairo(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.blue)),
                        const SizedBox(height: 6),
                        Text('الحالة: ${appeal.status}',
                            style: GoogleFonts.cairo(
                                fontSize: 12, color: AppColors.blue)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  PrimaryButton(
                      label: 'متابعة حالة التظلم', onPressed: onTrack),
                  const SizedBox(height: 8),
                  SecondaryButton(
                      label: 'العودة إلى سجل الدرجات',
                      onPressed: onBackToGrades),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppealTrackingScreen extends StatelessWidget {
  final GradeAppeal appeal;
  final VoidCallback onBack;
  const AppealTrackingScreen(
      {super.key, required this.appeal, required this.onBack});

  Color _statusColor() {
    if (appeal.status == 'تم القبول') return AppColors.success;
    if (appeal.status == 'تم الرفض') return AppColors.danger;
    if (appeal.status == 'يحتاج إلى معلومات إضافية') return AppColors.warning;
    return AppColors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(
                title: 'متابعة التظلم',
                sub: appeal.trackingNumber,
                onBack: onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appeal.courseName,
                            style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.text)),
                        Text('${appeal.courseCode} · ${appeal.examType}',
                            style: GoogleFonts.cairo(
                                fontSize: 12, color: AppColors.textSub)),
                        const Divider(height: 24),
                        _detail('الدرجة الحالية', appeal.currentGrade),
                        _detail('سبب التظلم', appeal.reason),
                        _detail('تاريخ التقديم', appeal.submittedAt),
                        _detail('رقم التتبع', appeal.trackingNumber),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: color.withValues(alpha: 0.25))),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: color, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text('حالة التظلم: ${appeal.status}',
                                style: GoogleFonts.cairo(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: color))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('تفاصيل الطلب',
                      style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border)),
                    child: Text(appeal.details,
                        style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: AppColors.textSub,
                            height: 1.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detail(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 105,
                child: Text(label,
                    style: GoogleFonts.cairo(
                        fontSize: 11, color: AppColors.textMuted))),
            Expanded(
                child: Text(value,
                    style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text))),
          ],
        ),
      );
}
