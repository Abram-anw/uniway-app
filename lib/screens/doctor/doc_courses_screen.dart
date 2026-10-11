import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icon.dart';
import '../../models/mock_data.dart';
import '../../widgets/common.dart';

/// قائمة مقررات الدكتور للفصل الحالي.
class DocCoursesScreen extends StatelessWidget {
  final ValueChanged<String> onNav;
  const DocCoursesScreen({super.key, required this.onNav});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(title: 'مقرراتي', subtitle: 'الفصل الثاني 1446'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: docCourses.map((c) {
                  return InkWell(
                    onTap: () => onNav('doc-course-detail'),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(c.name, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.text)),
                                  Text('${c.code} · ${c.section}', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted)),
                                ],
                              ),
                              const AppIcon('chevronLeft', size: 16, strokeWidth: 2, color: AppColors.textMuted),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(children: [
                            const AppIcon('users', size: 13, strokeWidth: 2, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text('${c.students} طالباً', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                            const SizedBox(width: 12),
                            const AppIcon('clock', size: 13, strokeWidth: 2, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Text(c.schedule, style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                          ]),
                          const SizedBox(height: 8),
                          Row(children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => onNav('doc-grades'),
                                style: ElevatedButton.styleFrom(backgroundColor: c.submitted ? AppColors.successLight : AppColors.blueLight, foregroundColor: c.submitted ? AppColors.success : AppColors.blue, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: Text('الدرجات', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => onNav('doc-lectures'),
                                style: OutlinedButton.styleFrom(foregroundColor: AppColors.textSub, side: const BorderSide(color: AppColors.border), padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: Text('المحاضرات', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// تفاصيل مقرر واحد: تبويبات الطلاب / الدرجات / المحاضرات.
class DocCourseDetailScreen extends StatefulWidget {
  final ValueChanged<String> onNav;
  final VoidCallback onBack;
  const DocCourseDetailScreen({super.key, required this.onNav, required this.onBack});

  @override
  State<DocCourseDetailScreen> createState() => _DocCourseDetailScreenState();
}

class _DocCourseDetailScreenState extends State<DocCourseDetailScreen> {
  String _tab = 'students';
  static const _names = ['أحمد العمري', 'سارة الزهراني', 'خالد المطيري', 'نورة السبيعي', 'عمر الشهري'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'هندسة البرمجيات', sub: 'CS401 · شعبة 1 · 42 طالباً', onBack: widget.onBack),
            Container(
              decoration: const BoxDecoration(color: AppColors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Row(
                children: [
                  Expanded(child: _tabBtn('students', 'الطلاب')),
                  Expanded(child: _tabBtn('grades', 'الدرجات')),
                  Expanded(child: _tabBtn('lectures', 'المحاضرات')),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  if (_tab == 'students')
                    Container(
                      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                      child: Column(
                        children: List.generate(_names.length, (i) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () => widget.onNav('doc-students'),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: const BoxDecoration(color: AppColors.blueLight, shape: BoxShape.circle),
                                      alignment: Alignment.center,
                                      child: Text(_names[i][0], style: GoogleFonts.cairo(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700)),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(_names[i], style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                                          Text('44101${(i + 1).toString().padLeft(5, '0')}', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(20)),
                                      child: Text('A-', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
                                    ),
                                  ]),
                                ),
                              ),
                              if (i < _names.length - 1) const Divider(height: 1, color: AppColors.border, indent: 64),
                            ],
                          );
                        }),
                      ),
                    ),
                  if (_tab == 'grades')
                    Column(
                      children: [
                        PrimaryButton(label: 'رفع الدرجات', onPressed: () => widget.onNav('doc-upload-grades')),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.warning.withValues(alpha: 0.25))),
                          child: Text('الدرجات لم تُرفع بعد لهذا المقرر', style: GoogleFonts.cairo(fontSize: 12, color: AppColors.warning, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  if (_tab == 'lectures') PrimaryButton(label: 'رفع محاضرة جديدة', onPressed: () => widget.onNav('doc-upload-lecture')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBtn(String id, String label) {
    final active = _tab == id;
    return InkWell(
      onTap: () => setState(() => _tab = id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: active ? AppColors.blue : Colors.transparent, width: 2))),
        child: Text(label, style: GoogleFonts.cairo(fontSize: 13, fontWeight: active ? FontWeight.w700 : FontWeight.w400, color: active ? AppColors.blue : AppColors.textMuted)),
      ),
    );
  }
}

class _StudentRow {
  final String name, id, grade;
  final double gpa;
  final int attend;
  const _StudentRow(this.name, this.id, this.gpa, this.grade, this.attend);
}

const _studentRows = [
  _StudentRow('أحمد العمري', '4410112345', 4.0, 'A', 90),
  _StudentRow('سارة الزهراني', '4410112346', 3.8, 'A-', 95),
  _StudentRow('خالد المطيري', '4410112347', 3.5, 'B+', 85),
  _StudentRow('نورة السبيعي', '4410112348', 3.2, 'B', 88),
  _StudentRow('عمر الشهري', '4410112349', 2.9, 'C+', 75),
];

/// قائمة الطلاب التفصيلية لمقرر الدكتور مع المعدل ونسبة الحضور.
class DocStudentsScreen extends StatelessWidget {
  final VoidCallback onBack;
  const DocStudentsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      child: SafeArea(
        child: Column(
          children: [
            BackHeader(title: 'قائمة الطلاب', sub: 'هندسة البرمجيات · 42 طالباً', onBack: onBack),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: Column(
                      children: List.generate(_studentRows.length, (i) {
                        final s = _studentRows[i];
                        final gradeColor = s.grade.startsWith('A') ? AppColors.success : s.grade.startsWith('B') ? AppColors.blue : AppColors.warning;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: const BoxDecoration(color: AppColors.blueLight, shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Text(s.name[0], style: GoogleFonts.cairo(fontSize: 14, color: AppColors.blue, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(s.name, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.text)),
                                      Text('${s.id} · حضور ${s.attend}%', style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: gradeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                                  child: Text(s.grade, style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w900, color: gradeColor)),
                                ),
                              ]),
                            ),
                            if (i < _studentRows.length - 1) const Divider(height: 1, color: AppColors.border, indent: 66),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
